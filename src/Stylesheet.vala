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
namespace Stylesheet {
	public const string BODY = """
		@define-color colorPrimary #ffcb5c;
		.container GtkButton {
			background: #e6e6e6;
			border-radius: 0px;
			border: none;
			text-shadow: none;
			box-shadow: none;
			padding: 8px 0 8px 0;
			text-shadow: 0 1px 0 rgba(255,255,255,0.25), 0 -1px 0 rgba(0,0,0,0.125);
		}
		.container GtkGrid {
			background-color: #ffffff;
		}
		.container GtkBox {
			background-color: #ffffff;
		}
		GtkBox.shadow {
			box-shadow: 0 0 3px rgba(0,0,0,0.5);
			font-weight: normal;
		}
		GtkBox.shadow GtkButton {
			border-top: 1px solid rgba(255,255,255,0.25);
			border-bottom: 1px solid rgba(0,0,0,0.05);
		}
		GtkBox.preshadow GtkButton {
			border-bottom: 1px solid rgba(0,0,0,0.15);
		}
		""";
}
