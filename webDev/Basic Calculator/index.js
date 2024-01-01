let operator = {
    "/":[],
    "x":[],
    "+":[],
    "-":[]
};
let values = [];
let ans = 0;
function clicked(btnVar){
    switch(btnVar){
        case "AC":document.getElementById("input").innerHTML=""; document.getElementById("output").innerHTML="";
        break;
        case "DEL":let cr = document.getElementById("input").innerText.split("");cr.pop();document.getElementById("input").innerHTML =cr.join("") ;
        break;
        case ".": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat(".");
        break;
        case "x": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("x");
        break;
        case "÷": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("÷");
        break;
        case "+": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("+");
        break;
        case "-": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("-");
        break;
        case "x10": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("x10");
        break;
        case "=":document.getElementById('output').innerHTML = seperator();/*if(seperator()!==0){document.getElementById('output').innerHTML = cal(seperator()[0],seperator()[1],operator);}else if(seperator()===1){document.getElementById("output").innerHTML = "ans";}else{document.getElementById('output').innerHTML = document.getElementById('input').innerText};*/
        break;
        case "ANS": document.getElementById("input").innerHTML = document.getElementById("input").innerText.concat(ans) ;
        break;
        default: document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat(btnVar);
        break;
    }
}
function seperator(){
    let docTxt = document.getElementById("input").textContent;
    /*to use for replacing unrecognized operator
    docTxt.replace(/÷/g,'/');
    docTxt.replace(/x/g,"*");
    docTxt.replace(/+/g,'+');
    docTxt.replace(/-/g,'-');*/
    docTxt = docTxt.replace(/x/g,"*").replace(/÷/g,'/');
    var result = eval(docTxt);
    ans = result*1;
    return result;
}
