import React from "react";

let Modal = React.createClass({
  render() {
    return (
      <div className="modal" style={{display: "block", backgroundColor: "rgba(0, 0, 0, 0.5)" }}>
        <div className="modal-dialog">
          <div className="modal-content">
            {this.props.children}
          </div>
        </div>
      </div>
    );
  }
});
Modal.Header = React.createClass({
  render() {
    return (
      <div className="modal-header">
        <button type="button" className="close" onClick={this.props.onHide}><span>&times;</span></button>
        {this.props.children}
      </div>
    );
  }
});
Modal.Body = React.createClass({
  render() {
    return (
      <div className="modal-body">
        {this.props.children}
      </div>
    );
  }
});
Modal.Footer = React.createClass({
  render() {
    return (
      <div className="modal-footer">
        {this.props.children}
      </div>
    );
  }
});

export default Modal;
