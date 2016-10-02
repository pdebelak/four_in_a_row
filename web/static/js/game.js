import React from 'react';
import qwest from 'qwest';

import Board from './board';

export default class extends React.Component {
  constructor() {
    super();

    this.state = {
      board: null,
      game: null,
    };
  }

  componentDidMount() {
    this.fetchBoard();
  }

  fetchBoard() {
    qwest.get(`/games/${this.props.params.id}`, {}, { dataType: 'json' })
      .then((_, response) =>
        this.setState({ game: response.game, board: response.board })
      );
  }

  makeMove(col) {
    qwest.put(`/games/${this.props.params.id}`, { column: col, player: this.state.game.active_player }, { dataType: 'json' })
      .then((_, response) =>
        this.setState({ game: response.game, board: response.board })
      );
  }

  render() {
    if (!this.state.board) { return null; }
    return (
      <Board
        board={this.state.board}
        active
        makeMove={(col) => this.makeMove(col)}
      />
    );
  }
}
