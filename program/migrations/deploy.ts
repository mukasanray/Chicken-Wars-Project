// Anchor migration deploy script
const anchor = require("@coral-xyz/anchor");

module.exports = async function (provider) {
  // Configure client to use the provider
  anchor.setProvider(provider);

  // Add your deploy script here
  console.log("Chicken Wars — Migration deploy");
};
