// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "algolia_autocomplete"
document.addEventListener("turbo:before-fetch-request", (event) => {
  if (event.target.hasAttribute("data-turbo-preload") && event.target.dataset.turboPreload === "false") {
    event.preventDefault();
  }
});
