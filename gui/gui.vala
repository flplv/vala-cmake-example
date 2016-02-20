namespace MyProject.GUI {
    class Application : Gtk.Application {
        protected override void activate () {
            Gtk.Builder builder = new Gtk.Builder ();
            try {
                builder.add_from_resource ("/com/github/felipe-lavratti/vala-unittests-cmake/main-window.ui");
            } catch (GLib.Error e) {
                GLib.error ("Unable to load resources: %s", e.message);
            }

            Gtk.ApplicationWindow window = builder.get_object ("main-window") as Gtk.ApplicationWindow;
            if (window == null)
                GLib.error ("Unable to load main window");

            window.application = this;
            window.show ();
        }

        public Application () {
            Object (application_id: "org.github.felipe-lavratti.vala-unittests-cmake.gui");
        }
    }
}

private static int main (string[] args) {
    var app = new MyProject.GUI.Application ();
    return app.run (args);
}