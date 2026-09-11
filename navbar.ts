import { NavbarItem } from "@docusaurus/theme-common";

const navbarItems: NavbarItem[] = [
    {
        type: "docSidebar",
        sidebarId: "tutorialSidebar",
        position: "left",
        label: "Tutorial",
    },
    {
        label: 'Engenharia',
        to: 'pathname:///engenharia/index.html', // Maps to static/engenharia/index.html  to: 'pathname:///engenharia/index.html', // Link to a page in your API docs
        position: 'left',
    },
    { to: "/blog", label: "Blog", position: "left" },
    {
        href: "https://github.com/ruseleredu/tcc-docs",
        label: "GitHub",
        position: "right",
    },
];

export default navbarItems;
