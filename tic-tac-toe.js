var filename = 'tic-tac-toe.wasm';

var init_ttt;
var play_turn;
var list_get;
var list_size;
var module;

var buffer = readbuffer(filename);
//var blob = window.open(filename);
//var fileReader = new FileReader();
//var buffer = fileReader.readAsArrayBuffer(blob);
module = Wasm.instantiateModule(buffer, {});
init_ttt = module.exports['init_ttt'];
play_turn = module.exports['play_turn'];
list_get = module.exports['list_get'];
list_size = module.exports['list_size'];
init_ttt(0);

function playTurn(x, y, who){
    play_turn(0, x, y, who);
    print();
    print("=========");
    print_game();
    print("=========");
    print();
}

function print_game () {
    print_part(0);
    print_part(3);
    print_part(6);
}

function print_part(mul) {
    //print(list_size(0));
    var i = 0;
    var word = "|";
    while (i < 3 && (i+mul) < list_size(0)) {
        //print(i+mul);
        var val = list_get(0, i+mul);
        if (val === 0) {
            word = word + "-";
        }
        else if (val === 1) {
            word = word + "X";
        }
        else if (val === 2) {
            word = word + "O";
        }
        i++;
    }
    word = word + "|";
    print(word);
}
