import React from "react/react";
import { IndexLink, Router, Route, Link, browserHistory } from "react-router";

export default React.createClass({
  render() {
    return (
      <nav className="navbar navbar-default" role="navigation">
        <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false">
          <span className="glyphicon glyphicon-menu-hamburger"></span>
        </button>

        <div className="nav navbar-header">
          <a className="navbar-brand" href="/"><span className="glyphicon glyphicon-home"></span> 家計簿さん</a>
        </div>

        <div className="collapse navbar-collapse" id="navbar-collapse">
          <ul className="nav navbar-nav navbar-right">
            <li><IndexLink to="/"            activeClassName="active" ><span className="glyphicon glyphicon-list-alt"></span> 履歴</IndexLink></li>
            <li><Link      to="/inventories" activeClassName="active" ><span className="glyphicon glyphicon-check"></span> 棚卸し</Link></li>
          </ul>
        </div>
      </nav>
    );
  }
});
