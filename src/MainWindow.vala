/*
License: ISC
Copyright (c) 2017, 柯禕藍 <yhilan.ko@gmail.com>

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR b
IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
*/
using Gtk;
using Gdk;
using Granite;
using Granite.Services;
using Granite.Widgets;
public class MainWindow : Gtk.Window {
	private GLib.Settings settings = new GLib.Settings ( "com.github.keyilan.swatches" );
	private string hexValue = "000000";
	private double steps = 23; // number of steps excluding the given colour
	private int stepsint = 23;
	private bool show_labels = true;
	private string originalColour = "";
	private string initialColor;
	private bool showrgb;
	private bool onChangeActivated = true;
	private int window_x = 0;
	private int window_y = 0;
	public Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (Gdk.Display.get_default (), Gdk.SELECTION_CLIPBOARD);
	public MainWindow (Gtk.Application application) {
		GLib.Object (application: application,
			icon_name: "com.github.keyilan.swatches",
			resizable: false,
			title: "Swatches",
			border_width: 0
		);
		Granite.Widgets.Utils.set_theming_for_screen (
			this.get_screen (),
			Stylesheet.BODY,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
		if (settings.get_boolean("first-run")) {
			this.set_position ( Gtk.WindowPosition.CENTER );
			settings.set_boolean ( "first-run", false );
			showrgb = settings.set_boolean("show-rgb",false);
		} else {
			showrgb = settings.get_boolean("show-rgb");
			initialColor = settings.get_string("last-colour");
			window_x = settings.get_int ("window-x");
			window_y = settings.get_int ("window-y");
			this.move (window_x, window_y);
		}
		Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = false;
	}
	construct {
		Gtk.Entry input = new Gtk.Entry();
		string inputtext = input.get_text();
		Gtk.MenuBar bar = new Gtk.MenuBar ();

		Gtk.MenuItem item_labelhide = new Gtk.MenuItem.with_label ("Visibility");
		Gtk.Menu labelhide_menu = new Gtk.Menu ();
		Gtk.RadioMenuItem item_showlabels = new Gtk.RadioMenuItem.with_label (null, "Visible");
		unowned SList<Gtk.RadioMenuItem> showhidegroup = item_showlabels.get_group ();
		Gtk.RadioMenuItem item_hidelabels = new Gtk.RadioMenuItem.with_label (showhidegroup, "Hidden");
		labelhide_menu.add (item_showlabels);
		labelhide_menu.add (item_hidelabels);
		item_labelhide.set_submenu (labelhide_menu);
		show_labels = settings.get_boolean("show-labels");
		if (show_labels == true) {
			item_showlabels.set_active(true);
		} else {
			item_hidelabels.set_active(true);
		}
		item_hidelabels.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("show-labels",false);
			show_labels = false;
			input.set_text (inputtext+";");
		});
		item_showlabels.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("show-labels",true);
			show_labels = true;
			input.set_text (inputtext+";");
		});

		Gtk.MenuItem item_options = new Gtk.MenuItem.with_label ("Labels");
		bar.add (item_options);
		Gtk.Menu options_menu = new Gtk.Menu ();
		item_options.set_submenu (options_menu);

		Gtk.MenuItem item_values = new Gtk.MenuItem.with_label ("Values");
		options_menu.add (item_values);
		options_menu.add (item_labelhide);

		labelhide_menu.add (item_values);
		Gtk.Menu values_menu = new Gtk.Menu ();
		Gtk.RadioMenuItem item_disp_hex = new Gtk.RadioMenuItem.with_label (null, "Hexadecimal");
		unowned SList<Gtk.RadioMenuItem> rgbgroup = item_disp_hex.get_group ();
		Gtk.RadioMenuItem item_disp_rgb = new Gtk.RadioMenuItem.with_label (rgbgroup, "RGB");
		bool show_rgb = settings.get_boolean("show-rgb");
		if (show_rgb == true) {
			item_disp_rgb.set_active(true);
		} else {
			item_disp_hex.set_active(true);
		}
		values_menu.add (item_disp_hex);
		values_menu.add (item_disp_rgb);
		item_values.set_submenu (values_menu);
		item_disp_hex.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("show-rgb",false);
			show_rgb = false;
			input.set_text (inputtext+";");
		});
		item_disp_rgb.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("show-rgb",true);
			show_rgb = true;
			input.set_text (inputtext+";");
		});
		Gtk.MenuItem item_luminance = new Gtk.MenuItem.with_label ("Luminance");
		bar.add (item_luminance);
		Gtk.Menu luminance_menu = new Gtk.Menu ();
		Gtk.RadioMenuItem item_lum_real = new Gtk.RadioMenuItem.with_label (null, "Actual");
		unowned SList<Gtk.RadioMenuItem> lumgroup = item_lum_real.get_group ();
		Gtk.RadioMenuItem item_lum_perc = new Gtk.RadioMenuItem.with_label (lumgroup, "Perceptual");
		bool perceptual_luminance = settings.get_boolean("perceptual-luminance");
		if (perceptual_luminance == true) {
			item_lum_perc.set_active(true);
		} else {
			item_lum_real.set_active(true);
		}
		luminance_menu.add (item_lum_perc);
		luminance_menu.add (item_lum_real);
		item_luminance.set_submenu (luminance_menu);
		item_lum_real.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("perceptual-luminance",false);
			perceptual_luminance = false;
			input.set_text (inputtext+";");
		});
		item_lum_perc.activate.connect (() => {
			inputtext = input.get_text();
			settings.set_boolean("perceptual-luminance",true);
			perceptual_luminance = true;
			input.set_text (inputtext+";");
		});
		Gtk.Button[] buttons = new Gtk.Button[stepsint];
		var rows = new Gtk.Box[stepsint];
		var grids = new Gtk.Grid[stepsint];
		Gtk.Button[] brights = new Gtk.Button[stepsint];
		Gtk.Grid parentgrid = new Gtk.Grid();
		Gtk.Grid grid = new Gtk.Grid();
		grid.set_column_homogeneous(true);
		parentgrid.set_column_homogeneous(true);
		parentgrid.set_row_spacing(0);
		grid.set_row_spacing(0);
		grid.set_column_spacing(0);
		Gtk.Label rgblabel = new Gtk.Label ("rgb");
		Gtk.Label hexlabel = new Gtk.Label ("hex");
		Gtk.Box innerbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Gtk.Box outerbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		innerbox.pack_start (input, true, true, 0);
		outerbox.pack_start (innerbox, true, true, 6);
		parentgrid.attach(bar, 0, 0, 1, 1);
		parentgrid.attach(outerbox, 0, 1, 1, 1);
		parentgrid.attach(grid, 0, 2, 1, 1);
		this.add (parentgrid);
		parentgrid.get_style_context ().add_class ("container");
		input.set_placeholder_text("enter hex code");
		input.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear");
		input.icon_press.connect ((pos, event) => {
			if (pos == Gtk.EntryIconPosition.SECONDARY) {
				input.set_text ("");
			}
		});
		for (int i = 0; i <= stepsint; i++) {
			rows[i] = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
			grids[i] = new Gtk.Grid();
			grids[i].set_column_homogeneous(true);
			buttons[i] = new Gtk.Button.with_label ("");
			buttons[i].clicked.connect (button_clicked);
			brights[i] = new Gtk.Button.with_label ("");
			brights[i].clicked.connect (button_clicked);
			grids[i].attach (buttons[i], 0, 0, 1, 1);
			grids[i].attach (brights[i], 1, 0, 1, 1);
			rows[i].pack_start (grids[i], true, true, 0);
			grid.attach(rows[i], 0, i, 1, 1);
		}
		input.changed.connect (() => {
			if (onChangeActivated == true) {
				hexValue = input.get_text();
				if (hexValue.substring (hexValue.length-1, 1) == ";") {
					hexValue = hexValue.substring (0, hexValue.length-1);
				}
				if (hexValue.substring (0, 3) == "rgb") {
					hexValue = rgb2hex(hexValue);
				}
				hexValue = hexValue.replace (" ", "");
				input.text = hexValue;
				if (hexValue.length > 6 && hexValue.substring (0, 3) != "rgb") {
					if (hexValue.substring (0, 1) == "#") {
						hexValue = hexValue.substring (1, 6);
					} else {
						hexValue = hexValue.substring (0, 6);
					}
					input.text = hexValue;
				}
				originalColour = hexValue;
				if (hexValue.length == 6) {
					double redval = hex2rgb(hexValue.substring (0, 2));
					double greenval = hex2rgb(hexValue.substring (2, 2));
					double blueval = hex2rgb(hexValue.substring (4, 2));
					double luminancevalue = (double)((redval + blueval + greenval)/3);

					perceptual_luminance = settings.get_boolean("perceptual-luminance");
					double luminance;
					if (perceptual_luminance == true) {
						double perceptual = (0.299*redval + 0.587*greenval + 0.114*blueval);
						luminance = steps - Math.round((perceptual/256)*steps); // <-- percieved luminance. make togglable later
					} else {
						luminance = steps - Math.round((luminancevalue/256)*steps); // <-- actual luminance
					}
					int positionkey = (int)luminance;

					// calculate bright steps
					double rangemin = Math.fmin (redval, greenval);
						rangemin = Math.fmin (rangemin, blueval);
					double rangemax = Math.fmax (redval, greenval);
						rangemax = Math.fmax (rangemax, blueval);
					double upperval = (255 - rangemin); // the distance from 255 to highest rgb value
					double lowerval = rangemax; // the distance from 0 to the lowest value
					double brightlower = stepsint - positionkey;
					double brightupper = positionkey;
					double brightlowersteps = lowerval / brightlower;
					double brightuppersteps = upperval / brightupper;
					string originalrgb = "rgb("+redval.to_string()+","+greenval.to_string()+","+blueval.to_string()+")";
					string original = rgb2hex(originalrgb);
					int o = 1;

					// clear all labels
					for (int i = 0; i <= stepsint; i++) {
						buttons[i].set_label("");
						brights[i].set_label("");
						rows[i].get_style_context ().remove_class ("shadow");
						rows[i].get_style_context ().remove_class ("preshadow");
					}

					//make sure we have the right setting
					showrgb = settings.get_boolean("show-rgb");

					// everything above the given colour
					for (int i = positionkey - 1; i >= 0; i--) {
						double redstep = Math.round((255 - redval) / positionkey);
						double newred = Math.round(redval + (redstep * o));
						double greenstep = Math.round((255 - greenval) / positionkey);
						double newgreen = Math.round(greenval + (greenstep * o));
						double bluestep = Math.round((255 - blueval) / positionkey);
						double newblue = Math.round(blueval + (bluestep * o));
						if (newred > 255) {newred = 255;}
						if (newgreen > 255) {newgreen = 255;}
						if (newblue > 255) {newblue = 255;};
						string thisrgb  = "rgb("+newred.to_string()+","+newgreen.to_string()+","+newblue.to_string()+")";
						string thishex  = rgb2hex(thisrgb);
						string shownvalue;
						if (showrgb == false) {
							shownvalue = thishex;
						} else {
							shownvalue = thisrgb;
						}
						buttons[i].set_label(shownvalue);
						ApplyCSS({buttons[i]}, @"*{background-color:"+shownvalue+";}");
						ApplyCSS({buttons[i]}, @"*{font-weight:normal;}");
						if (show_labels == false) {
							ApplyCSS({buttons[i]}, @"*{color:rgba(0,0,0,0);}");
							ApplyCSS({buttons[i]}, @"*{text-shadow:none;}");
						} else {
							if (i > steps/2) {
								ApplyCSS({buttons[i]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
							} else {
								ApplyCSS({buttons[i]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
							}
						}
						// brights
						double brightred = Math.round(redval + (brightuppersteps * o));
						double brightgreen = Math.round(greenval + (brightuppersteps * o));
						double brightblue = Math.round(blueval + (brightuppersteps * o));
						if (brightred > 255) {brightred = 255;}
						if (brightgreen > 255) {brightgreen = 255;}
						if (brightblue > 255) {brightblue = 255;};
						string brightrgb  = "rgb("+brightred.to_string()+","+brightgreen.to_string()+","+brightblue.to_string()+")";
						string brighthex  = rgb2hex(brightrgb);
						if (showrgb == false) {
							shownvalue = brighthex;
						} else {
							shownvalue = brightrgb;
						}
						brights[i].set_label(shownvalue);
						ApplyCSS({brights[i]}, @"*{background-color:"+brighthex+";}");
						ApplyCSS({brights[i]}, @"*{font-weight:normal;}");
						if (show_labels == false) {
							ApplyCSS({brights[i]}, @"*{color:rgba(0,0,0,0);}");
							ApplyCSS({brights[i]}, @"*{text-shadow:none;}");
						} else {
							if (i > steps/2) {
								ApplyCSS({brights[i]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
							} else {
								ApplyCSS({brights[i]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
							}
						}
						o++;
					}
					o = 1; // reset
					// everything below the given colour
					for (int i = positionkey + 1; i <= stepsint; i++) {
						// regular
						double redstep = Math.round(redval / (steps - positionkey));
						double newred = Math.round(redval - (redstep * o));
						double greenstep = Math.round(greenval / (steps - positionkey));
						double newgreen = Math.round(greenval - (greenstep * o));
						double bluestep = Math.round(blueval / (steps - positionkey));
						double newblue = Math.round(blueval - (bluestep * o));
						if (newred < 0) {newred = 0;}
						if (newgreen < 0) {newgreen = 0;}
						if (newblue < 0) {newblue = 0;};
						string thisrgb  = "rgb("+newred.to_string()+","+newgreen.to_string()+","+newblue.to_string()+")";
						string thishex  = rgb2hex(thisrgb);

						string shownvalue;
						if (showrgb == false) {
							shownvalue = thishex;
						} else {
							shownvalue = thisrgb;
						}
						if (showrgb == false) {
							shownvalue = thishex;
						} else {
							shownvalue = thisrgb;
						}
						buttons[i].set_label(shownvalue);
						ApplyCSS({buttons[i]}, @"*{background-color:"+thishex+";}");
						ApplyCSS({buttons[i]}, @"*{font-weight:normal;}");
						if (show_labels == false) {
							ApplyCSS({buttons[i]}, @"*{color:rgba(0,0,0,0);}");
							ApplyCSS({buttons[i]}, @"*{text-shadow:none;}");
						} else {
							if (i > steps/2) {
								ApplyCSS({buttons[i]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
							} else {
								ApplyCSS({buttons[i]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
							}
						}
						// brights
						double brightred = Math.round(redval - (brightlowersteps * o));
						double brightgreen = Math.round(greenval - (brightlowersteps * o));
						double brightblue = Math.round(blueval - (brightlowersteps * o));
						if (brightred < 0) {brightred = 0;}
						if (brightgreen < 0) {brightgreen = 0;}
						if (brightblue < 0) {brightblue = 0;};
						string brightrgb  = "rgb("+brightred.to_string()+","+brightgreen.to_string()+","+brightblue.to_string()+")";
						string brighthex  = rgb2hex(brightrgb);
						if (showrgb == false) {
							shownvalue = brighthex;
						} else {
							shownvalue = brightrgb;
						}
						brights[i].set_label(shownvalue);
						ApplyCSS({brights[i]}, @"*{background-color:"+brighthex+";}");
						ApplyCSS({brights[i]}, @"*{font-weight:normal;}");
						if (show_labels == false) {
							ApplyCSS({brights[i]}, @"*{color:rgba(0,0,0,0);}");
							ApplyCSS({brights[i]}, @"*{text-shadow:none;}");
						} else {
							if (i > steps/2) {
								ApplyCSS({brights[i]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
							} else {
								ApplyCSS({brights[i]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
							}
						}
						o++;
					}
					// set for the given colour's buttons
					ApplyCSS({buttons[positionkey]}, @"*{background-color:"+original+";}");
					ApplyCSS({brights[positionkey]}, @"*{background-color:"+original+";}");
					if (show_labels == false) {
						ApplyCSS({buttons[positionkey]}, @"*{color:rgba(0,0,0,0);}");
						ApplyCSS({buttons[positionkey]}, @"*{text-shadow:none;}");
						ApplyCSS({brights[positionkey]}, @"*{color:rgba(0,0,0,0);}");
						ApplyCSS({brights[positionkey]}, @"*{text-shadow:none;}");
					} else {
						if (positionkey >= steps/2) {
							ApplyCSS({buttons[positionkey]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
							ApplyCSS({brights[positionkey]}, @"*{color:rgba(255,255,255,0.75); text-shadow: 0 -1px 0 rgba(0,0,0,0.25);}");
						} else {
							ApplyCSS({buttons[positionkey]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
							ApplyCSS({brights[positionkey]}, @"*{color:rgba(0,0,0,0.85); text-shadow: 0 1px 0 rgba(255,255,255,0.4);}");
						}
					}
					string shownvalue;
					if (showrgb == false) {
						shownvalue = original;
					} else {
						shownvalue = originalrgb;
						onChangeActivated = false;
						input.set_text (originalrgb);
						onChangeActivated = true;
					}
					buttons[positionkey].set_label(shownvalue);
					brights[positionkey].set_label(shownvalue);
					rows[positionkey].get_style_context().add_class("shadow");
					int r = positionkey-1;
					if (r >= 0) {
						rows[r].get_style_context().add_class("preshadow");
					}
					settings.set_string ("last-colour", shownvalue);
				}
			}
		});
		initialColor = settings.get_string("last-colour");
		if (initialColor!= null) {
			input.text = initialColor;
			input.text = initialColor+";";
		}
	}
	public void button_clicked (Gtk.Button button) {
		ApplyCSS({button}, @"*{font-weight:bold;}");
		string buttonlabel = button.get_label();
		CopyToClipboard(buttonlabel);
	}
	public void CopyToClipboard(string hex) {
		clipboard.set_text (hex, hex.length);
		var notification = new Notification (_(hex));
		notification.set_body (_("copied to clipboard"));
		GLib.Application.get_default ().send_notification ("copied", notification);
	}
	public void ApplyCSS (Widget[] widgets, string CSS) {
		var Provider = new Gtk.CssProvider ();
		try {
			Provider.load_from_data (CSS, -1);
			foreach(var widget in widgets) {widget.get_style_context().add_provider(Provider,-1);}
		} catch (GLib.Error e) {
			warning(e.message);
		}
	}
	public string rgb2hex(string input) {
		Gdk.RGBA color = Gdk.RGBA();
			color.parse(input);
		string hex = "#%02x%02x%02x".printf(
			(uint)(Math.round(color.red*255)),
			(uint)(Math.round(color.green*255)),
			(uint)(Math.round(color.blue*255))).up();
		return hex;
	}
	public int hex2rgb(string hex) {
		int dec = 0;
		var tens = hex[0];
		var ones = hex[1];
		if (tens == '0') {dec = 0;}
		else if (tens == '1') {dec = 16;} else if (tens == '2') {dec = 32;} else if (tens == '3') {dec = 48;}
		else if (tens == '4') {dec = 64;} else if (tens == '5') {dec = 80;} else if (tens == '6') {dec = 96;}
		else if (tens == '7') {dec = 112;} else if (tens == '8') {dec = 128;} else if (tens == '9') {dec = 144;}
		else if (tens == 'a' || tens == 'A') {dec = 160;} else if (tens == 'b' || tens == 'B') {dec = 176;}
		else if (tens == 'c' || tens == 'C') {dec = 192;} else if (tens == 'd' || tens == 'D') {dec = 208;}
		else if (tens == 'e' || tens == 'E') {dec = 224;} else if (tens == 'f' || tens == 'F') {dec = 240;}
		if (ones == '0') {dec += 0;}
		else if (ones == '1') {dec += 1;} else if (ones == '2') {dec += 2;} else if (ones == '3') {dec += 3;}
		else if (ones == '4') {dec += 4;} else if (ones == '5') {dec += 5;} 	else if (ones == '6') {dec += 6;}
		else if (ones == '7') {dec += 7;} else if (ones == '8') {dec += 8;} else if (ones == '9') {dec += 9;}
		else if (ones == 'a' || ones == 'A') {dec += 10;} else if (ones == 'b' || ones == 'B') {dec += 11;}
		else if (ones == 'c' || ones == 'C') {dec += 12;} else if (ones == 'd' || ones == 'D') {dec += 13;}
		else if (ones == 'e' || ones == 'E') {dec += 14;} else if (ones == 'f' || ones == 'F') {dec += 15;}
		return dec;
	}
}
