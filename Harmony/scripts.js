function handleFirstTab(e) {
    if (e.keyCode === 9) {
        document.body.classList.add('user-is-tabbing');
        window.removeEventListener('keydown', handleFirstTab);
    }
}

window.addEventListener('keydown', handleFirstTab);

document.addEventListener("keyup", function(event) {
      if (event.code === 'Enter') {
        var searchField = document.getElementById("search")
        var searchFieldText = searchField.value
        searchFieldText = searchFieldText.replace(" ", "+")
        window.location.assign("https://search:" + searchFieldText)
        print(searchFieldText)
      }
    });
