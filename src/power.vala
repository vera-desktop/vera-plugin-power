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
using Gee;

namespace PowerPlugin {

	public class Plugin : Peas.ExtensionBase, VeraPlugin {

		private string HOME = Environ.get_variable(null, "HOME");
		
		private Up.Client client;
		private Up.Device[] devices;
		
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
		
		public void startup(StartupPhase phase) {
			/**
			 * Called by vera when doing the startup.
			*/
			
			if (phase == StartupPhase.OTHER) {
				
				this.client = new Up.Client();
				
				new PowerTray(this.client);
			}
			
		}
		

	}
}

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
	Peas.ObjectModule objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type(typeof(VeraPlugin), typeof(PowerPlugin.Plugin));
}
