import React from "react";
import Modal from "components/modal";
import InputItemAndAmount from "components/entryModal/input-item-and-amount";

export default React.createClass({
  getInitialState() {
    return {
      date: new Date(),
      debits:  [{ id: "debit0" , item_id: null, amount: null, side_id: 1 }],
      credits: [{ id: "credit0", item_id: null, amount: null, side_id: 2 }]
    };
  },
  handleCancel(e) {
    e.preventDefault();
    this.setState(this.getInitialState());
    this.props.onCancel(e);
  },
  handleSubmit(e) {
    e.preventDefault();
    $.ajax({
      url: this.props.url,
      dataType: "json",
      method: "POST",
      data: { transaction: {
        date: this.state.date.toISOString(),
        entries: _.select(this.state.debits.concat(this.state.credits), (one) => {
          return one.item_id && one.amount;
        })
      }}
    }).done((data) => {
      this.props.onSave(data);
      this.setState(this.getInitialState());
    }).fail((xhr, status, err) => {
      console.error(this.props.url, status, err.toString());
    });
  },
  handleChangeDate() {
    var newVal = Date.parse(ReactDOM.findDOMNode(this.refs.date).value);
    if (newVal) this.setState({ date: new Date(newVal) })
  },
  handleChangeDebit(data) {
    var newDebits = this.state.debits;
    _.extend(_.findWhere(newDebits, { id: data.id }), data);

    if (_.last(this.state.debits).amount) {
      this.setState({ debits: newDebits.concat({ id: "debit" + newDebits.length, item_id: null, amount: null, side_id: 1 }) });
    } else {
      this.setState({ debits: newDebits });
    }
  },
  handleChangeCredit(data) {
    var newCredits = this.state.credits;
    _.extend(_.findWhere(newCredits, { id: data.id }), data);

    if (_.last(this.state.credits).amount) {
      this.setState({ credits: newCredits.concat({ id: "credit" + newCredits.length, item_id: null, amount: null, side_id: 2 }) });
    } else {
      this.setState({ credits: newCredits });
    }
  },
  render() {
    if (!this.props.show) return <div />;

    var debits = this.state.debits.map((one) => {
      return (<InputItemAndAmount key={one.id} items={this.props.items} data={one} onChange={this.handleChangeDebit}/>);
    });
    var credits = this.state.credits.map((one) => {
      return (<InputItemAndAmount key={one.id} items={this.props.items} data={one} onChange={this.handleChangeCredit}/>);
    });
    return (
      <Modal>
        <form className="form" onSubmit={this.handleSubmit}>
          <Modal.Header onHide={this.handleCancel}>
            <h4>{this.props.title}</h4>
          </Modal.Header>
          <Modal.Body>
            <div className="form-group">
              <div className="input-group">
                <div className="input-group-addon"><span className="glyphicon glyphicon-time"></span></div>
                <input className="form-control" type="date"
                       value={this.state.date.toISOString().substring(0, 10)}
                       onChange={this.handleChangeDate} ref="date" />
              </div>
            </div>

            <section>
              <legend>借方</legend>
              <div className="form-group">
                {debits}
              </div>
            </section>

            <section>
              <legend>貸方</legend>
              <div className="form-group">
                {credits}
              </div>
            </section>
          </Modal.Body>
          <Modal.Footer>
            <button type="button" className="btn btn-default" onClick={this.handleCancel}>キャンセル</button>
            <button type="submit" className="btn btn-primary">OK</button>
          </Modal.Footer>
        </form>
      </Modal>
    );
  }
});
