/*
Copyright (c) 2017, 柯禕藍 <yhilan.ko@gmail.com>

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
*/
using Gtk;
using Gdk;

//valac --pkg gtk+-3.0 --pkg glib-2.0 --pkg granite -X -lm Application.vala MainWindow.vala Stylesheet.vala && ./Applicationcd ..

public class MainWindow : Gtk.Window {
		//8932f7 // ff1364 // problem colours
		//private string hexval; // globals go here
		private string hexValue = "000000"; // the value of the colour that just changed
		//private int lumValue = 0; // where in the list does it fall
		private double steps = 16; // how many steps to display
		private int stepsint = 16;
		public Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (Gdk.Display.get_default (), Gdk.SELECTION_CLIPBOARD);

		public MainWindow (Gtk.Application application) {
			GLib.Object (application: application,
				//icon_name: "com.github.keyilan.swatches",
				resizable: true,
				title: "Swatches",
				height_request: 500,
				width_request: 500,
				border_width: 8
			);
			Granite.Widgets.Utils.set_theming_for_screen (
				this.get_screen (),
				Stylesheet.BODY,
				Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
			);
			this.get_style_context ().add_class ("rounded");
			this.window_position = Gtk.WindowPosition.CENTER;
			//var icon = new Gtk.Image.from_icon_name ("com.github.lainsce.coin-symbolic", Gtk.IconSize.DIALOG);
		}
		construct {
			Gtk.Entry input = new Gtk.Entry();
			Gtk.Entry perception = new Gtk.Entry();
			Gtk.Entry val = new Gtk.Entry(); // luminence
			Gtk.Entry stepsdownentry = new Gtk.Entry();
			Gtk.Entry stepsupentry = new Gtk.Entry();
			Gtk.Button[] buttons = new Gtk.Button[stepsint];
			Gtk.Button[] brights = new Gtk.Button[stepsint];
			Gtk.Label inputlabel = new Gtk.Label ("input");
			Gtk.Label stepslabel = new Gtk.Label ("steps");
			Gtk.Label vallabel = new Gtk.Label ("luminance");
			Gtk.Label percep = new Gtk.Label ("percieved");

			Gtk.Grid grid = new Gtk.Grid();
			grid.set_row_homogeneous(true);
			grid.set_column_homogeneous(true);
			grid.set_row_spacing(0);
			grid.set_column_spacing(4);
			this.add (grid);

			//grid.attach(inputlabel, 0, 0, 1, 1);
			grid.attach(input, 0, 0, 2, 1);
			input.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "preferences-desktop-theme");

			/*Gtk.Toolbar bar = new Gtk.Toolbar ();
			Gtk.Image img = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.SMALL_TOOLBAR);
			Gtk.ToolButton button1 = new Gtk.ToolButton (img, null);
			button1.clicked.connect (() => {
				stdout.printf ("Button 1\n");
			});
			bar.add (button1);
			grid.attach (bar,0,0,2,1);*/

			//grid.attach(stepslabel, 0, 6, 1, 1);
			//grid.attach(stepsupentry, 0, 7, 1, 1);
			//grid.attach(stepsdownentry, 0, 8, 1, 1);
			//grid.attach(vallabel, 0, 9, 1, 1);
			//grid.attach(val, 0, 10, 1, 1);
			//grid.attach(percep, 0, 11, 1, 1);
			//grid.attach(perception, 0, 12, 1, 1);
			for (int i = 0; i < stepsint; i++) {
				buttons[i] = new Gtk.Button.with_label ("");
				buttons[i].clicked.connect (button_clicked);
				grid.attach(buttons[i], 0, i+1, 1, 1);
				brights[i] = new Gtk.Button.with_label ("");
				brights[i].clicked.connect (button_clicked);
				grid.attach(brights[i], 1, i+1, 1, 1);
			}
			input.changed.connect (() => {
				hexValue = input.get_text();
				hexValue = hexValue.replace (" ", "");
				input.text = hexValue;
				if (hexValue.length > 6) {
					if (hexValue.substring (0, 1) == "#") {
						hexValue = hexValue.substring (1, 6);
					} else {
						hexValue = hexValue.substring (0, 6);
					}
					input.text = hexValue;
				}
				if (hexValue.length == 6) {
					// to RGB
					double redval = hex2rgb(hexValue.substring (0, 2));
					double greenval = hex2rgb(hexValue.substring (2, 2));
					double blueval = hex2rgb(hexValue.substring (4, 2));

					double lumval = (double)((redval + blueval + greenval)/3);
					double per = (0.299*redval + 0.587*greenval + 0.114*blueval);
					//perception.set_text(Math.round(per).to_string());
					double lumpos = steps - Math.round((lumval/256)*steps); // <-- actual luminance
					//double lumpos = steps - Math.round((per/256)*steps); // <-- percieved luminance
					int positionkey = (int)lumpos;
					//val.set_text(Math.round(lumval).to_string()); //9cd039
					//for (int e = 0; e < stepsint; e++) {
						//labels[e].set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, null);
					//}

					// calculate bright steps
					double rangemin;
					double rangemax;
					if (redval < greenval) {
						rangemin = redval;
					} else {
						rangemin = greenval;
					}
					if (rangemin > blueval) {
						rangemin = blueval;
					}
					if (redval > greenval) {
						rangemax = redval;
					} else {
						rangemin = greenval;
					}
					if (rangemax < blueval) {
						rangemax = blueval;
					}

					//double rangemin = Math.fmin (redval, greenval);
					//	rangemin = Math.fmin (rangemin, blueval);
					//double rangemax = Math.fmax (redval, greenval);
					//	rangemax = Math.fmax (rangemax, blueval);
					double upperval = (255 - rangemin); // the distance from 255 to highest rgb value
					double lowerval = rangemax; // the distance from 0 to the lowest value
					double brightlower = stepsint - positionkey;
					double brightupper = positionkey;
					double brightlowersteps = lowerval / brightlower;
					double brightuppersteps = upperval / brightupper;
					string originalrgb = "rgb("+redval.to_string()+","+greenval.to_string()+","+blueval.to_string()+")";
					string original = rgb2hex(originalrgb);
					int o = 1;
					for (int i = 0; i < stepsint; i++) {
						buttons[i].set_label("");
						brights[i].set_label("");
					}
					for (int i = positionkey - 1; i >= 0; i--) {
						double redstep = Math.round((255 - redval) / positionkey);
						//stepsupentry.set_text(redstep.to_string());
						double newred = redval + (redstep * o);
						double brightred = redval + (brightuppersteps * o);
						if (newred > 255) {newred = 255;}
						if (brightred > 255) {brightred = 255;}
						double greenstep = Math.round((255 - greenval) / positionkey);
						double newgreen = greenval + (greenstep * o);
						double brightgreen = greenval + (brightuppersteps * o);
						if (newgreen > 255) {newgreen = 255;}
						if (brightgreen > 255) {brightgreen = 255;}
						double bluestep = Math.round((255 - blueval) / positionkey);
						double newblue = blueval + (bluestep * o);
						double brightblue = blueval + (brightuppersteps * o);
						if (newblue > 255) {newblue = 255;};
						if (brightblue > 255) {brightblue = 255;};
						string thisrgb  = "rgb("+newred.to_string()+","+newgreen.to_string()+","+newblue.to_string()+")";
						string brightrgb  = "rgb("+brightred.to_string()+","+brightgreen.to_string()+","+brightblue.to_string()+")";
						string thishex  = rgb2hex(thisrgb);
						string brighthex  = rgb2hex(brightrgb);
						o++;
						ApplyCSS({buttons[i]}, @"*{background-color:"+thishex+";}");
						ApplyCSS({brights[i]}, @"*{background-color:"+brighthex+";}");
						if (i > steps/2) {
							ApplyCSS({buttons[i]}, @"*{color:#ffffff;}");
							ApplyCSS({brights[i]}, @"*{color:#ffffff;}");
						} else {
							ApplyCSS({buttons[i]}, @"*{color:#000000;}");
							ApplyCSS({brights[i]}, @"*{color:#000000;}");
						}
						ApplyCSS({buttons[i]}, @"*{font-weight:normal;}");
						ApplyCSS({brights[i]}, @"*{font-weight:normal;}");
						buttons[i].set_label(thishex);
						brights[i].set_label(brighthex);
					}
					o = 1;
					for (int i = positionkey + 1; i < stepsint; i++) {
						double redstep = Math.round(redval / (steps-positionkey));
						//stepsdownentry.set_text(redstep.to_string());
						double newred = redval - (redstep * o);
						double brightred = redval - (brightlowersteps * o);
						if (newred < 0) {newred = 0;}
						if (brightred < 0) {brightred = 0;}
						double greenstep = Math.round(greenval / (steps-positionkey));
						double newgreen = greenval - (greenstep * o);
						double brightgreen = greenval - (brightlowersteps * o);
						if (newgreen < 0) {newgreen = 0;}
						if (brightgreen < 0) {brightgreen = 0;}
						double bluestep = Math.round(blueval / (steps-positionkey));
						double newblue = blueval - (bluestep * o);
						double brightblue = blueval - (brightlowersteps * o);
						if (newblue < 0) {newblue = 0;};
						if (brightblue < 0) {brightblue = 0;};
						string thisrgb  = "rgb("+newred.to_string()+","+newgreen.to_string()+","+newblue.to_string()+")";
						string brightrgb  = "rgb("+brightred.to_string()+","+brightgreen.to_string()+","+brightblue.to_string()+")";
						string thishex  = rgb2hex(thisrgb);
						string brighthex  = rgb2hex(brightrgb);
						o++;
						ApplyCSS({buttons[i]}, @"*{background-color:"+thishex+";}");
						ApplyCSS({brights[i]}, @"*{background-color:"+brighthex+";}");
						if (i > steps/2) {
							ApplyCSS({buttons[i]}, @"*{color:#ffffff;}");
							ApplyCSS({brights[i]}, @"*{color:#ffffff;}");
						} else {
							ApplyCSS({buttons[i]}, @"*{color:#000000;}");
								ApplyCSS({brights[i]}, @"*{color:#000000;}");
						}
						buttons[i].set_label(thishex);
						brights[i].set_label(brighthex);
						ApplyCSS({buttons[i]}, @"*{font-weight:normal;}");
						ApplyCSS({brights[i]}, @"*{font-weight:normal;}");
					}
					ApplyCSS({buttons[positionkey]}, @"*{background-color:"+original+";}");
					ApplyCSS({brights[positionkey]}, @"*{background-color:"+original+";}");
					if (positionkey >= steps/2) {
						ApplyCSS({buttons[positionkey]}, @"*{color:#ffffff;}");
						ApplyCSS({brights[positionkey]}, @"*{color:#ffffff;}");
					} else {
						ApplyCSS({buttons[positionkey]}, @"*{color:#000000;}");
						ApplyCSS({brights[positionkey]}, @"*{color:#000000;}");
					}
					buttons[positionkey].set_label(original);
					brights[positionkey].set_label(original);
					ApplyCSS({buttons[positionkey]}, @"*{font-weight:normal;}");
					ApplyCSS({brights[positionkey]}, @"*{font-weight:normal;}");
				}
			});
			input.text = "ffcb5c";
			input.text = "#ffcb5c";
		}
		public void button_clicked (Gtk.Button button) {
			ApplyCSS({button}, @"*{font-weight:bold;}");
			string buttonlabel = button.get_label();
			CopyToClipboard(buttonlabel);
		}
		public void CopyToClipboard(string hex) {
			clipboard.set_text (hex, hex.length);
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
