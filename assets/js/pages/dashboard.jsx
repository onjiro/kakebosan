import React from "react";
import NewEntryButtonForm from "components/new-entry-button-form";
import RecentHistory from "components/recent-history";
import EntryModal from "components/entry-modal";
import Notice from "components/notice";
import moment from "moment";
import axios from "axios";
import _ from "lodash";

export default React.createClass({
  getInitialState() {
    return {
      currentTransaction: null,
      transactionDateFrom: null,
      transactionDateTo: null,
      transactions: []
    };
  },
  componentDidMount() {
    var dateFrom = moment().subtract(7, 'days').toISOString();
    var dateTo = null;
    this.loadHistories(dateFrom, dateTo);
  },
  loadHistories(dateFrom, dateTo) {
    Promise.all([
      axios.get(`api/transactions`, { data: {
        dateFrom: dateFrom,
        dateTo:   dateTo
      } }),
      axios.get(`api/items`)
    ]).then((res) => {
      var [transactionResponse, itemsResponse] = res;
      var currentTransactions = this.state.transactions;
      this.setState({
        transactionDateFrom: dateFrom,
        transactions: currentTransactions.concat(res[0].data.data),
        items: res[1].data.data
      });
    }).catch((err) => {
      this.error("エラーが発生しました。");
      throw err;
    });
  },
  deleteTransaction(transaction) {
    axios.delete(`${this.props.url}/transactions/${transaction.id}`).then((data) => {
      this.setState({
        transactions: _(this.state.transactions).reject((one) => one.id === transaction.id)
      });
      this.info("登録を削除しました。");
    }).catch((err) => {
      console.log(err);
      this.error("エラーが発生しました。");
    });
  },
  loadFollowingHistories() {
    var dateTo = moment(this.state.transactionDateFrom).subtract(1, 'day');
    var dateFrom = dateTo.clone().subtract(1, 'month');
    this.loadHistories(dateFrom.toISOString(), dateTo.toISOString());
  },
  handleSave(data) {
    this.refs["entryModal"].close();
    this.setState({ transactions: [data].concat(this.state.transactions) });
    this.info("登録しました。");
  },
  openNewEntryModal() {
    this.refs["entryModal"].open();
  },
  openEntryModal(transaction) {
    this.refs["entryModal"].open(transaction);
  },
  info(text) {
    this.setState({ notice: {type: "info", text: text} });
    setTimeout(() => this.setState({ notice: null }), 2000); // todo 別のnoticeが削除される可能性がある
  },
  error(text) {
    this.setState({ notice: {type: "danger", text: text} });
    setTimeout(() => this.setState({ notice: null }), 2000);
  },
  render() {
    var notice = (this.state.notice) && (<Notice type={this.state.notice.type}>{this.state.notice.text}</Notice>);

    return (
      <div>
        {notice}
        <NewEntryButtonForm onClick={this.openNewEntryModal}>登録</NewEntryButtonForm>
        <RecentHistory data={this.state.transactions}
                       dateFrom={this.state.transactionDateFrom}
                       loadFollowingHistories={this.loadFollowingHistories}
                       openEditModal={this.openEntryModal}
                       deleteTransaction={this.deleteTransaction}/>

        <EntryModal ref="entryModal"
                    title="登録" url="api/transactions"
                    items={this.state.items}
                    editTarget={this.state.currentTransaction}
                    show={this.state.currentTransaction}
                    onSave={this.handleSave} />
      </div>
    );
  }
});