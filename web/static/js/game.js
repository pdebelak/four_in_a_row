import React from 'react';
import qwest from 'qwest';

import socket from './socket';
import Board from './board';

socket.connect();

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
    const channel = socket.channel(`game:${this.props.params.id}`, {});
    channel.join()
      .receive('ok', (response) => { console.log('Connected:', response); })
      .receive('error', (response) => { console.log('There was a problem:', response) });

    channel.on('new_move', (response) => {
      this.setState({ game: response.game, board: response.board });
    });
  }

  fetchBoard() {
    qwest.get(`/games/${this.props.params.id}`, null, { dataType: 'json' })
      .then((_, response) =>
        this.setState({ game: response.game, board: response.board })
      );
  }

  makeMove(col) {
    qwest.put(
      `/games/${this.props.params.id}`,
      { column: col, player: this.props.location.query.player },
      { dataType: 'json' }
    ).then((_, response) =>
        this.setState({ game: response.game, board: response.board })
      );
  }

  render() {
    if (!this.state.board) { return null; }
    return (
      <Board
        board={this.state.board}
        active={this.state.game.active_player == this.props.location.query.player}
        makeMove={(col) => this.makeMove(col)}
      />
    );
  }
}
