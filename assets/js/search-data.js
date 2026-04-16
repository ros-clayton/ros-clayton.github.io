// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "About",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-current-research",
          title: "Current Research",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/current-research/";
          },
        },{id: "nav-conference-presentations",
          title: "Conference Presentations",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/conference-presentations/";
          },
        },{id: "nav-policy-engagements",
          title: "Policy Engagements",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/policy-reports/";
          },
        },];
