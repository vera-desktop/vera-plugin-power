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

using Vera;

namespace PowerPlugin {

	public class Plugin : VeraPlugin, Peas.ExtensionBase {
		
		private Up.Client client;
		
		private PowerTray power_tray;
		
		public Display display;
		public Settings settings;
				
		public void init(Display display) {
			/**
			 * Initializes the plugin.
			*/
			
			
			try {
				this.display = display;
					
				//this.settings = new Settings("org.semplicelinux.vera.power");

				//this.settings.changed.connect(this.on_settings_changed);

			} catch (Error ex) {
				error("Unable to load plugin settings.");
			}
	
		}
		
		private void create_power_tray() {
			/**
			 * Creates the power tray and shows it.
			*/
			
			this.power_tray = new PowerTray(this.client);
			
		}
		
		private void destroy_power_tray() {
			/**
			 * Destroys the power tray.
			*/
			
			this.power_tray.destroy();
			this.power_tray = null;
		}
		
		private bool check_for_batteries() {
			/**
			 * Returns True if at least one battery has been found,
			 * False otherwise.
			*/
			
			
			bool found = false;
			
			this.client.get_devices().foreach(
				(device) => {
					
					if (device.is_present && device.kind != Up.DeviceKind.LINE_POWER)
						found = true;
						return;
				
				}
			);
			
			
			return found;
		}
		
		public void startup(StartupPhase phase) {
			/**
			 * Called by vera when doing the startup.
			*/
			
			if (phase == StartupPhase.OTHER || phase == StartupPhase.SESSION) {
				
				this.client = new Up.Client();
				
				if (this.check_for_batteries()) {
					this.create_power_tray();
				}
				
				/* Show/remove tray when needed */
				this.client.device_added.connect(
					(device) => {
						if (this.power_tray == null && this.check_for_batteries()) {
							this.create_power_tray();
						}
					}
				);
				this.client.device_removed.connect(
					(device) => {
						if (this.power_tray != null && !this.check_for_batteries()) {
							this.destroy_power_tray();
						}
					}
				);
								
			}
			
		}
		
		public void shutdown() {
			/**
			 * Cleanup.
			*/
			
			this.destroy_power_tray();
			this.client = null;
			
		}
	}
}

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
	Peas.ObjectModule objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type(typeof(VeraPlugin), typeof(PowerPlugin.Plugin));
}
