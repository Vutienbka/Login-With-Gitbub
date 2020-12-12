// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs

//= require turbolinks
//= require_tree .

function loadMoreRepositories(link) {
  var container = link.parentElement;
  container.classList.add('loading');

  fetch(link.href).then(function(response) {
    response.text().then(function(text) {
      container.insertAdjacentHTML('afterend', text);
      container.remove();
    })
  })
}

function toggleStar(el) {
  fetch(el.action, { method: 'PUT', headers: { 'X-Requested-With': 'XMLHttpRequest' } }).then(function(response) {
    response.text().then(function(text) {
      // Parse text to get an actual element
      var div = document.createElement('div')
      div.innerHTML = text

      // Find the star container
      var container = el.closest('.star-badge')
      container.replaceWith(div.firstElementChild)
    })
  })
}

document.addEventListener('submit', function(e) {
  var form = e.target
  toggleStar(form)
  e.preventDefault()
})

// Basic event delegation
document.addEventListener('click', function(e) {
  var loadMoreLink = e.target.closest('.js-load-more')
  if (loadMoreLink) {
    loadMoreRepositories(loadMoreLink)
    e.preventDefault()
  }
})
