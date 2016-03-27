var filename = 'tic-tac-toe.wasm';

var init_ttt;
var play_turn;
var list_get;
var list_size;
var module;
var buff;
//var buffer = readbuffer(filename);
//var blob = window.open(filename);
//var fileReader = new FileReader();
//var buffer = fileReader.readAsArrayBuffer(blob);

var xhr = new XMLHttpRequest;
xhr.open('GET', filename, false);
//xhr.responseType = "arraybuffer";
xhr.overrideMimeType('text/plain; charset=x-user-defined');
xhr.send(null);
//buff = intArrayFromString(xhr.responseText, true);
//buff  = new Uint8Array(buff);
//module = Wasm.instantiateModule(buff, {});
buff = str2ab(xhr.response);
var temp = new Uint8Array(buff);
module = Wasm.instantiateModule(temp, {});
init_ttt = module.exports['init_ttt'];
play_turn = module.exports['play_turn'];
list_get = module.exports['list_get'];
list_size = module.exports['list_size'];
init_ttt(0);
var body = document.getElementById("test");

function playTurn(x, y, who){
    play_turn(0, x, y, who);
    appendToBody("");
    appendToBody("=========");
    print_game();
    appendToBody("=========");
    appendToBody("");
}

function appendToBody(str){
  body.innerHTML = body.innerHTML +"<br>"+ str +"</br>";
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
            word = word + "--";
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
    appendToBody(word);
}

//Found form the internet. :) - modifyed though
// https://developers.google.com/web/updates/2012/06/How-to-convert-ArrayBuffer-to-and-from-String?hl=en
function str2ab(str) {
  var buf = new ArrayBuffer(str.length); // 2 bytes for each char
  var bufView = new Uint8Array(buf);
  for (var i=0, strLen=str.length; i < strLen; i++) {
    bufView[i] = str.charCodeAt(i);
  }
  return buf;
}
