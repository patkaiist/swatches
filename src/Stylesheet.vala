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
