import qwest from 'qwest';

import socket from './socket';

socket.connect();

function findGameId() {
  const path = window.location.pathname;
  if (path.match(/\/games\/.*/)) {
    return window.location.pathname.replace(/\/games\//, '');
  }
  return null;
}
const gameId = findGameId();
if (gameId) {
  console.log(gameId);
  const channel = socket.channel(`game:${gameId}`, {});
  channel.join()
    .receive('ok', (response) => { console.log('Connected:', response); })
    .receive('error', (response) => { console.log('There was a problem:', response) });

  channel.on('new_move', () => {
    window.location.reload();
  });
}


const csrf = document.querySelector('meta[name=token]').content;

const activeCols = document.querySelectorAll('.board.active .board--col');
for (let i = 0; i < activeCols.length; i++) {
  const col = i;
  activeCols[i].addEventListener('click', () => {
    qwest.put('', { column: col + 1, _csrf_token: csrf }, { dataType: 'json' })
      .then(() => window.location.reload());
  });
}
