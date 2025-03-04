// check for saved darkmode in localStorage
let darkMode = localStorage.getItem('darkMode'); 
let dark_value = localStorage.getItem('dark_value');
const darkModeToggle = document.querySelector('#mode');
// Will load color scheme based on browser preference
if (! localStorage.dark_value) {
	if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
		meta.setAttribute("content", "#000000");
		document.body.classList.add('D');
	}
}
const enableDarkMode = () => {
	// 1. Add the class to the body
	document.body.classList.add('D');
	// 2. Update darkMode in localStorage
	localStorage.setItem('darkMode', '1');
}
const disableDarkMode = () => {
	// 1. Remove the class from the body
	document.body.classList.remove('D');
	// 2. Update darkMode in localStorage
	localStorage.setItem('darkMode', null);
}
// If the user already visited and enabled darkMode
// start things off with it on
if (darkMode === '1') {
	enableDarkMode();
}
// When someone clicks the button
darkModeToggle.addEventListener('click', () => {
	// get their darkMode setting
	darkMode = localStorage.getItem('darkMode');
	// if it not current enabled, enable it
	if (darkMode !== '1') {
		enableDarkMode();
		localStorage.setItem('dark_value', '1');
		// if it has been enabled, turn it off
	} else {
		disableDarkMode();
		localStorage.setItem('dark_value', null);
	}
});
