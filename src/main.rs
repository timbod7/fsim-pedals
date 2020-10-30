//! CDC-ACM serial port example using interrupts.
#![no_std]
#![no_main]

extern crate panic_semihosting;

use cortex_m::asm::{delay};
use cortex_m_rt::entry;
use cortex_m::interrupt::free as disable_interrupts;
use embedded_hal::digital::v2::OutputPin;
use stm32f1xx_hal::stm32::{interrupt, Interrupt};
use stm32f1xx_hal::usb::{Peripheral, UsbBus, UsbBusType};
use stm32f1xx_hal::{prelude::*, stm32};
use usb_device::{bus::UsbBusAllocator, prelude::*};
use usbd_hid::hid_class::{HIDClass};
use usbd_hid::descriptor::MouseReport;
use usbd_hid::descriptor::generator_prelude::*;

static mut USB_BUS: Option<UsbBusAllocator<UsbBusType>> = None;
static mut USB_HID: Option<HIDClass<UsbBusType>> = None;
static mut USB_DEVICE: Option<UsbDevice<UsbBusType>> = None;

#[entry]
fn main() -> ! {
    let p = cortex_m::Peripherals::take().unwrap();
    let dp = stm32::Peripherals::take().unwrap();

    let mut flash = dp.FLASH.constrain();
    let mut rcc = dp.RCC.constrain();

    let clocks = rcc
        .cfgr
        .use_hse(8.mhz())
        .sysclk(48.mhz())
        .pclk1(24.mhz())
        .freeze(&mut flash.acr);

    assert!(clocks.usbclk_valid());

    let mut gpioa = dp.GPIOA.split(&mut rcc.apb2);

    // BluePill board has a pull-up resistor on the D+ line.
    // Pull the D+ pin down to send a RESET condition to the USB bus.
    // This forced reset is needed only for development, without it host
    // will not reset your device when you upload new firmware.
    let mut usb_dp = gpioa.pa12.into_push_pull_output(&mut gpioa.crh);
    usb_dp.set_low();
    delay(clocks.sysclk().0 / 100);

    let usb_dm = gpioa.pa11;
    let usb_dp = usb_dp.into_floating_input(&mut gpioa.crh);

    let usb = Peripheral {
        usb: dp.USB,
        pin_dm: usb_dm,
        pin_dp: usb_dp,
    };

    // Unsafe to allow access to static variables
    unsafe {
        let bus = UsbBus::new(usb);

        USB_BUS = Some(bus);
        use usbd_serial::{SerialPort, USB_CLASS_CDC};

        USB_HID = Some(HIDClass::new(USB_BUS.as_ref().unwrap(), MouseReport::desc(), 60));

        let usb_dev = UsbDeviceBuilder::new(USB_BUS.as_ref().unwrap(), UsbVidPid(0x16c0, 0x27dd))
            .manufacturer("twdkz")
            .product("Fsim Pedals")
            .serial_number("TEST")
            .device_class(0xEF) // misc
            .build();

        USB_DEVICE = Some(usb_dev);
    }

    let mut nvic = p.NVIC;

    nvic.enable(Interrupt::USB_HP_CAN_TX);
    nvic.enable(Interrupt::USB_LP_CAN_RX0);

    loop {
        delay(25 * 1024 * 1024);
        push_mouse_movement(MouseReport{x: 0, y: 10, buttons: 0}).ok().unwrap_or(0);
        delay(25 * 1024 * 1024);
        push_mouse_movement(MouseReport{x: 0, y: -10, buttons: 0}).ok().unwrap_or(0);
    }
}

fn push_mouse_movement(report: MouseReport) -> Result<usize, usb_device::UsbError> {
    disable_interrupts(|_| {
        unsafe {
            USB_HID.as_mut().map(|hid| {
                hid.push_input(&report)
            })
        }
    }).unwrap()
}

#[interrupt]
fn USB_HP_CAN_TX() {
    usb_interrupt();
}

#[interrupt]
fn USB_LP_CAN_RX0() {
    usb_interrupt();
}

fn usb_interrupt() {
    let usb_dev = unsafe { USB_DEVICE.as_mut().unwrap() };
    let hid = unsafe { USB_HID.as_mut().unwrap() };

    if !usb_dev.poll(&mut [hid]) {
        return;
    }
}
