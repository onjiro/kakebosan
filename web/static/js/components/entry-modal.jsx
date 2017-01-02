import React from "react";
import Modal from "components/modal";
import InputDate from "components/entryModal/input-date";
import InputItemAndAmount from "components/entryModal/input-item-and-amount";

export default React.createClass({
  // API
  open(transaction) {
    var toViewModel = (one) => {
      return {
        id: one.id,
        item_id: one.item.id,
        amount: one.amount
      };
    };
    this.setState({
      id: transaction.id,
      date: new Date(transaction.date).toISOString().substring(0, 10),
      debits:  _(transaction.entries).filter((one) => one.side_id === 1).map(toViewModel).value(),
      credits: _(transaction.entries).filter((one) => one.side_id === 2).map(toViewModel).value(),
      show: true
    });
  },
  close() {
    this.setState({ show: false });
  },
  // handlers
  handleCancel(e) {
    e.preventDefault();
    this.close();
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
    var newVal = Date.parse(this.refs.date.value());
    if (newVal) this.setState({ date: new Date(newVal).toISOString().substring(0, 10) });
  },
  handleChangeDebit(data) {
    _.extend(_.find(this.state.debits, { id: data.id }), data);
    this.setState({ debits: this.state.debits });
    // if (_.last(this.state.debits).amount) {
    //   this.setState({ debits: this.state.debits.concat({ id: "debit" + this.state.debits.length, item_id: null, amount: null, side_id: 1 }) });
    // } else {
    //   this.setState({ debits: this.state.debits });
    // }
  },
  handleChangeCredit(data) {
    _.extend(_.find(this.state.credits, { id: data.id }), data);
    this.setState({ credits: this.state.credits });
    // if (_.last(this.state.credits).amount) {
    //   this.setState({ credits: newCredits.concat({ id: "credit" + newCredits.length, item_id: null, amount: null, side_id: 2 }) });
    // } else {
    //   this.setState({ credits: newCredits });
    // }
  },
  render() {
    if (!this.state || !this.state.show) return (<div />);

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
              <InputDate value={this.state.date} onChange={this.handleChangeDate} ref="date"/>
            </div>

            <legend>借方</legend>
            <div className="form-group">{debits}</div>

            <legend>貸方</legend>
            <div className="form-group">{credits}</div>
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
