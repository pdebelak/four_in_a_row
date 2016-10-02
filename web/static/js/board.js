import React from 'react';

export default class extends React.Component {
  get boardClass() {
    return this.props.active ? 'board active' : 'board';
  }

  itemClass(item) {
    const defaultClass = 'board--item';
    if (item === null) { return defaultClass; }
    if (item === 1) { return `${defaultClass} ${defaultClass}__player-1`; }
    return `${defaultClass} ${defaultClass}__player-2`;
  }

  makeMove(column) {
    if (!this.props.active) { return; }
    this.props.makeMove(column);
  }

  renderCol(col, colIndex) {
    for (let i = col.length; i < 6; i++) {
      col.push(null);
    }
    return col.map((item, index) =>
      <div
        className={this.itemClass(item)}
        key={index + 1 * colIndex + 1}
      />);
  }

  renderBoard() {
    return this.props.board.map((col, index) =>
      <div
        key={index}
        className="board--col"
        onClick={() => this.makeMove(index + 1)}
      >
          {this.renderCol(col, index)}
      </div>);
  }

  render() {
    return <div className={this.boardClass}>{this.renderBoard()}</div>;
  }
}
({ board, active, makeMove }) => {
};

