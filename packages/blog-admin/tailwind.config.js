/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#faf8f5",
          100: "#f5f1ea",
          200: "#e8dfd0",
          300: "#d4c4ab",
          400: "#bca687",
          500: "#a38968",
          600: "#8a7255",
          700: "#6f5c45",
          800: "#5c4c3a",
          900: "#4d4033",
        },
      },
    },
  },
  plugins: [],
};
