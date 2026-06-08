<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=Manrope:wght@400;500;600;700&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        "colors": {
          "outline-variant": "#bfc9c1",
          "inverse-primary": "#95d4b3",
          "tertiary-fixed-dim": "#ffb3b2",
          "inverse-surface": "#2e312f",
          "on-error": "#ffffff",
          "surface-container-highest": "#e1e3df",
          "on-secondary-fixed-variant": "#0d503f",
          "surface-container": "#eceeea",
          "secondary-container": "#aeedd5",
          "secondary-fixed": "#b1efd8",
          "on-secondary-fixed": "#002118",
          "background": "#f8faf6",
          "secondary-fixed-dim": "#96d3bd",
          "on-tertiary-container": "#ffb8b8",
          "on-primary": "#ffffff",
          "on-background": "#191c1a",
          "primary-fixed": "#b1f0ce",
          "tertiary-fixed": "#ffdad9",
          "surface-container-high": "#e7e9e5",
          "surface-tint": "#2c694f",
          "tertiary": "#652d2e",
          "on-error-container": "#93000a",
          "on-surface": "#191c1a",
          "surface-container-low": "#f2f4f0",
          "on-secondary-container": "#316d5b",
          "surface-bright": "#f8faf6",
          "secondary": "#2c6956",
          "inverse-on-surface": "#eff1ed",
          "tertiary-container": "#814344",
          "on-tertiary-fixed-variant": "#703536",
          "outline": "#707973",
          "on-primary-fixed-variant": "#0e5138",
          "surface-container-lowest": "#ffffff",
          "primary": "#004830",
          "on-primary-fixed": "#002114",
          "on-surface-variant": "#404943",
          "primary-container": "#226046",
          "error-container": "#ffdad6",
          "primary-fixed-dim": "#95d4b3",
          "surface": "#f8faf6",
          "on-tertiary-fixed": "#390b0e",
          "on-primary-container": "#99d8b7",
          "error": "#ba1a1a",
          "on-secondary": "#ffffff",
          "surface-dim": "#d8dbd7",
          "surface-variant": "#e1e3df",
          "on-tertiary": "#ffffff"
        },
          "borderRadius": {
              "DEFAULT": "0.25rem",
              "lg": "0.5rem",
              "xl": "0.75rem",
              "full": "9999px"
          },
        "fontFamily": {
          "headline": ["Plus Jakarta Sans"],
          "body": ["Manrope"],
          "label": ["Manrope"]
        }
      },
    },
  }
</script>
<style>
  body { font-family: 'Manrope', sans-serif; background-color: #f8faf6; color: #191c1a; }
  .font-headline { font-family: 'Plus Jakarta Sans', sans-serif; }
  .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

  /* Accordion custom styling! */
  .nav-item[open] summary .expand-icon { transform: rotate(180deg); }
  .nav-item summary::-webkit-details-marker { display: none; }
  .nav-item summary { list-style: none; }
  #sidebar-nav {
      width: 18rem;
  }

  aside {
      width: 18rem !important;
  }
</style>
</head>