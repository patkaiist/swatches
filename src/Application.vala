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
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
*/
using Gtk;

public class Swatches : Granite.Application {
	private Window window;
	construct {
		//https://valadoc.org/granite/Granite.Application.html
		program_name = "Swatches";
		exec_name = "com.github.keyilan.swatches";
		app_years = "2017";
		//app_launcher =  "swatches.desktop";
		application_id = "com.github.keyilan.swatches";
		main_url = "https://github.com/keyilan/swatches";
		bug_url = "https://github.com/keyilan/swatches/issues";
		translate_url = "https://github.com/keyilan/swatches";
		about_authors = { "柯禕藍 <yhilan.ko@gmail.com>" };
		about_license_type = Gtk.License.CUSTOM;
		about_comments = "";
	}
	public Swatches () {}
	protected override void activate () {
		if (get_windows ().length () > 0) {
			get_windows ().data.present ();
			return;
		}
		var app_window = new MainWindow (this);
		app_window.show_all ();
	}
	public static int main (string[] args) {
		var app = new Swatches ();
		return app.run (args);
	}
}
