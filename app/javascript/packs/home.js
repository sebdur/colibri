import { gsap } from "gsap";
import { elementScrollIntoViewPolyfill } from "seamless-scroll-polyfill";

// ScrollIntoView 100% compatible
elementScrollIntoViewPolyfill();

// Timeline animation
const tl = gsap.timeline();

tl.to(".logo", { y: "0%", duration: 1.5, ease: "power1" })
  .to(".brand", { duration: 1.5, delay: 1 })
  .fromTo(".spinners", { opacity: 0 }, { opacity: 1, display: "block"}, "-=2.5")
  .to(".slider-div", { y: "-100%", duration: 1.2 })
  .to(".intro", { y: "-100%" }, "-=0.8")
  .fromTo(".index", { opacity: 0 }, { opacity: 1, duration: 0.8 });

// Selectors
const sections = document.querySelectorAll('.section-category');
const buttons = document.querySelectorAll('.btn-category');

// Activate button on scroll
function addActiveClass() {
  let index = sections.length;

  while(--index && window.scrollY + 85 < sections[index].offsetTop) {};

  buttons.forEach(button => {
    button.classList.remove('active');
  });

  buttons[index].classList.add('active');
};

window.addEventListener('scroll', addActiveClass);

// Scroll to category
function scrollToCategory(e) {
  e.preventDefault();
  const href = this.getAttribute('href');
  document.getElementById(href).scrollIntoView({
    behavior: "smooth"
  });
};

buttons.forEach(button => {
  button.addEventListener('click', scrollToCategory);
});

// Scroll to top button
const toTop = document.getElementById('toTop');
function scrollToTop(e) {
  e.preventDefault();
  const href = this.getAttribute('href');
  document.getElementById(href).scrollIntoView({
    behavior: "smooth"
  });
};
toTop.addEventListener('click', scrollToTop);

// Darkmode toggle
function userPreferesDarkMode() {
  return localStorage.getItem("darkMode") === "enabled";
}

function setThemePreference(value) {
  localStorage.setItem("darkMode", value || "disabled");
}

const enableDarkMode = () => {
  document.body.classList.add("dark");
};

const disableDarkMode = () => {
  document.body.classList.remove("dark");
};

function setTheme() {
  if (userPreferesDarkMode()) {
    enableDarkMode();
  } else {
    disableDarkMode();
  }
}

function darkMode() {
  const darkModeToggleButton = document.getElementById('mode');
  darkModeToggleButton.addEventListener('click', () => {
    if (userPreferesDarkMode()) {
      setThemePreference("disabled");
      disableDarkMode();
    } else {
      setThemePreference("enabled");
      enableDarkMode();
    }
  });
  setTheme();
}

darkMode();
