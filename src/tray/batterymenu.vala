/*
 * vera-plugin-power - power plugin for vera
 * Copyright (C) 2014  Eugenio "g7" Paolantonio and the Semplice Project
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *     Eugenio "g7" Paolantonio <me@medesimo.eu>
*/

namespace PowerPlugin {

	public struct DeviceInTray {
		/**
		 * The device "block" structure.
		*/
		
		public Gtk.ImageMenuItem battery_model;
		public Gtk.ImageMenuItem battery_status;
		public Gtk.ImageMenuItem battery_time;
	
	}
	
	public class PowerMenu : Gtk.Menu {
		/**
		 * This is the Menu that you'll get by left-clicking on the
		 * tray icon.
		*/
		
		private HashTable<Up.Device, DeviceInTray?> device_table = new HashTable<Up.Device, DeviceInTray?>(direct_hash, direct_equal);
		
		public PowerMenu() {
			/**
			 * Construct the object.
			*/
			
			Object();
			
			/*
			 * As the menu *may be* dynamic (for example we plug a
			 * phone or a wireless mouse), we need to force the
			 * menu redraw whenever the size changes.
			*/
			this.set_redraw_on_allocate(true);
			
			this.show_all();
		}
		
		public void remove_device(Up.Device device) {
			/**
			 * Removes the device.
			*/
			
			if (!device_table.contains(device))
				return;
			
			DeviceInTray dev_ = device_table.get(device);
			
			dev_.battery_model.destroy();
			dev_.battery_status.destroy();
			dev_.battery_time.destroy();
			
			device_table.remove(device);
			
		}			
		
		public void update_device(Up.Device device) {
			/**
			 * Updates the device.
			*/
			
			DeviceInTray dev_;
			
			if (!device_table.contains(device)) {
				/* New device! */
				dev_ = DeviceInTray();
				
				/* Battery model */
				string label, icon;
				icon = Common.get_device_icon(device);
				if (device.vendor != null && device.model != null) {
					label = @"$(device.vendor) $(device.model)";
				} else {
					label = Up.Device.kind_to_string((Up.DeviceKind)device.kind);
				}
				dev_.battery_model = new Gtk.ImageMenuItem.with_label(label);
				if (icon != null)
					dev_.battery_model.set_image(new Gtk.Image.from_icon_name(icon, Gtk.IconSize.MENU));
				dev_.battery_model.set_sensitive(false);
				dev_.battery_model.show();
				this.append(dev_.battery_model);
				
				/* Status */
				dev_.battery_status = new Gtk.ImageMenuItem();
				dev_.battery_status.set_image(new Gtk.Image());
				this.append(dev_.battery_status);
				
				/* Time */
				dev_.battery_time = new Gtk.ImageMenuItem();
				//dev_.battery_time.set_image(new Gtk.Image.from_icon_name("preferences-system-time", Gtk.IconSize.MENU));
				this.append(dev_.battery_time);
				
				this.device_table.insert(device, dev_);
			} else {
				/* Update! */
				dev_ = device_table.get(device);
			}
			

			/* Status */
			if (device.state > 0) {
				dev_.battery_status.set_label(Common.get_battery_status_with_percentage(device));
				((Gtk.Image)dev_.battery_status.get_image()).set_from_icon_name(Common.get_battery_icon(device), Gtk.IconSize.MENU);
				dev_.battery_status.show();
			} else {
				dev_.battery_status.hide();
			}
				
			/* Time */
			string device_time = Common.get_remaining_time(device);
			if (device_time != null) {
				dev_.battery_time.set_label(@"$device_time remaining");
				dev_.battery_time.show();
			} else {
				dev_.battery_time.hide();
			}
				
		}
		
	}

}
