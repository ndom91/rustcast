use gtk::{
    glib::{self, clone},
    prelude::*,
    Application,
};
use xdgkit::basedir::*;

const APP_ID: &str = "org.ndom91.rustcast";

fn main() -> glib::ExitCode {
    // Create a new application
    let app = Application::builder().application_id(APP_ID).build();

    // Connect to "activate" signal of `app`
    app.connect_activate(build_ui);

    // Run the application
    app.run()
}

fn collect_desktop_files() -> Vec<String> {
    let app_dirs: Vec<String> = convert_to_vec(applications());
    println!("{:#?}", app_dirs);
    app_dirs
}

fn build_ui(app: &Application) {
    let window = gtk::ApplicationWindow::new(app);
    window.set_default_size(400, 75);
    window.set_title(Some("Rustcast"));

    let search_button = gtk::ToggleButton::new();
    search_button.set_icon_name("system-search-symbolic");

    let container = gtk::Box::new(gtk::Orientation::Vertical, 6);
    window.set_child(Some(&container));

    let search_bar = gtk::SearchBar::builder()
        .valign(gtk::Align::Start)
        .key_capture_widget(&window)
        .search_mode_enabled(true)
        .build();

    container.append(&search_bar);

    let entry = gtk::SearchEntry::new();
    entry.set_hexpand(true);

    let list_store = gtk::ListStore::new(&[glib::Type::STRING]);

    let desktop_files = collect_desktop_files();
    for file in desktop_files {
        list_store.set(&list_store.append(), &[(0, &file)]);
    }

    let completion = gtk::EntryCompletion::new();
    completion.set_model(Some(&list_store));
    completion.set_text_column(0);
    entry.set_completion(Some(&completion));
    search_bar.set_child(Some(&entry));

    let label = gtk::Label::builder()
        .label("Type to start search")
        .vexpand(false)
        .halign(gtk::Align::Center)
        .valign(gtk::Align::Center)
        .css_classes(["large-title"])
        .build();

    container.append(&label);

    // entry.connect_search_changed(clone!(
    //     #[weak]
    //     label,
    //     move |entry| {
    //         if entry.text() != "" {
    //             label.set_text(&entry.text());
    //         } else {
    //             label.set_text("Type to start search");
    //         }
    //     }
    // ));

    entry.connect_search_changed(clone!(
        #[weak]
        window,
        move |entry| {
            let text = entry.text();
            if !text.is_empty() {
                label.set_text(&text);
                window.set_default_size(400, 300); // Expand the window
            } else {
                label.set_text("Type to start search");
                window.set_default_size(400, 75); // Reset to original size
            }
        }
    ));

    window.present();
}
