// Assigning dark mode values to 2 variables
let darkMode = localStorage.getItem('darkMode');
// class and theme set
const darkModeToggle = document.querySelector('#switch');
var word2 = document.getElementById("sword");
var meta = document.querySelector("meta[name=theme-color]");
// dark mode enable function
const enableDarkMode = () => {
	document.body.classList.add('D');
	meta.setAttribute("content", "#000000");
	word2.innerHTML = 'τ';
	localStorage.setItem('darkMode', '1');
}
// dark mode disable function
const disableDarkMode = () => {
	document.body.classList.remove('D');
	meta.setAttribute("content", "#f8f8eb");
	word2.innerHTML = 'λ';
	localStorage.setItem('darkMode', null);
}
// load dark mode to protect eyes from temp flash bang
if (darkMode === '1') {
	enableDarkMode();
}
// Will load color scheme based on browser preference
if (! localStorage.darkMode) {
	if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
		enableDarkMode();
	}
}
// the click function
darkModeToggle.addEventListener('click', () => {
	darkMode = localStorage.getItem('darkMode');
	if (darkMode !== '1') {
		enableDarkMode();
	} else {
		disableDarkMode();
	}
});
