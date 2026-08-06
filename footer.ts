import { ThemeConfig } from "@docusaurus/preset-classic";

const currentYear = new Date().getFullYear();

const formatter = new Intl.DateTimeFormat("pt-BR", {
    timeZone: "America/Sao_Paulo",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hourCycle: "h23",
});

const utc3Time = formatter.format(new Date());

// Using consistent styling for links
const linkStyle =
    'style="color: #ffffff; font-weight: bold;" target="_blank" rel="noopener noreferrer"';
const gitlink = `<a href="https://ruseleredu.github.io/tcc-docs/" ${linkStyle}>TCC Docs</a>`;
const docusaurusVersion = require("@docusaurus/core/package.json").version;
const doclink = `<a href="https://docusaurus.io/" ${linkStyle}>Docusaurus</a>  v${docusaurusVersion}`;

const COPYRIGHT_STRING = `Copyright © ${currentYear} ${gitlink}. Built with ${doclink} at ${utc3Time} (UTC-3).`;

// In your module.exports / export default:
// footer: { copyright: COPYRIGHT_STRING }
const footer: ThemeConfig["footer"] = {
    style: "dark",
    links: [
        {
            title: 'Docs',
            items: [
                {
                    label: 'Tutorial',
                    to: '/docs/intro',
                },
            ],
        },
        {
            title: 'Community',
            items: [
                {
                    label: 'Stack Overflow',
                    href: 'https://stackoverflow.com/questions/tagged/docusaurus',
                },
                {
                    label: 'Discord',
                    href: 'https://discordapp.com/invite/docusaurus',
                },
                {
                    label: 'X',
                    href: 'https://x.com/docusaurus',
                },
            ],
        },
        {
            title: 'More',
            items: [
                {
                    label: 'Blog',
                    to: '/blog',
                },
                {
                    label: 'GitHub',
                    href: 'https://github.com/facebook/docusaurus',
                },
            ],
        },
    ],
    copyright: COPYRIGHT_STRING,
};

export default footer;
