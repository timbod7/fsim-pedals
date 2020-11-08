

use usbd_hid::descriptor::generator_prelude::*;


/// MouseReport describes a report and its companion descriptor than can be used
/// to send joystick values to a host
#[gen_hid_descriptor(
    (collection = APPLICATION, usage_page = GENERIC_DESKTOP, usage = JOYSTICK) = {
        (collection = PHYSICAL, usage = POINTER) = {
            (usage = X,) = {
                #[item_settings data,variable,absolute]
                 x=input;
            };
        };
    }
)]
#[allow(dead_code)]
pub struct JoystickReport {
    pub x: u16
}