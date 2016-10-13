import "phoenix_html";
import socket from "socket";

import React from "react";
import ReactDOM from "react-dom";
import AppHeader from "app-header";
import Dashboard from "pages/dashboard";
import Inventories from "pages/inventories";
import { Router, Route, IndexRoute, Link, browserHistory } from "react-router";

let App = React.createClass({
  render() {
    return (
      <div>
        <AppHeader />
        <div className="container-fluid">
          <section className="content row">
            {this.props.children}
          </section>
        </div>
      </div>
    );
  }
});

ReactDOM.render(
  <Router history={browserHistory}>
    <Route path="/" component={App} url="/api">
      <IndexRoute component={Dashboard} />
      <Route path="/inventories" component={Inventories} />
    </Route>
  </Router>, document.getElementById("root"));
