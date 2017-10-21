var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
module.exports = {
  devtool: "source-map",
  entry: {
    app: ["./css/app.scss", "./js/app.jsx"]
  },
  output: {
    path: "../priv/static",
    filename: "js/app.js"
  },
  resolve: {
    modulesDirectories: [ "node_modules", __dirname + "/js" ],
    extensions: ["", ".js", ".jsx"]
  },
  module: {
    loaders: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: ["babel"],
      include: __dirname,
      query: {
        presets: ["react", "es2015"]
      }
    }, {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract("style", "css")
    }, {
      test: /\.scss$/,
      loader: ExtractTextPlugin.extract("style", "css!sass?includePaths[]=" + __dirname +  "/node_modules")
    }]
  },
  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./static" }]),
    new CopyWebpackPlugin([{ from: "./node_modules/bootstrap/dist" }]),
    new CopyWebpackPlugin([{ from: "./node_modules/react-select/dist", to: "css/" }])
  ]
};
