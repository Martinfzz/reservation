// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery";
import 'select2'

document.addEventListener("turbo:load", () => {
  const placeholder = document.getElementById("dashboard")?.dataset?.placeholder;

  $('.select2').select2({
    placeholder: placeholder,
  });
});