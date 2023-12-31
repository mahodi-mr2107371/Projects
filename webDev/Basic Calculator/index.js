let operator = "";
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
        case "/": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("/");
        break;
        case "+": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("+");
        break;
        case "-": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("-");
        break;
        case "x10": document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat("x10");
        break;
        case "=":if(seperator()!==0){document.getElementById('output').innerHTML = cal(seperator()[0],seperator()[1],operator);}else if(seperator()===1){document.getElementById("output").innerHTML = ans;}else{document.getElementById('output').innerHTML = document.getElementById('input').innerText};ans= document.getElementById('output').innerText;
        break;
        case "ANS": document.getElementById("input").innerHTML = document.getElementById("input").innerText.concat("ANS") ;
        break;
        default: document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat(btnVar);
        break;
    }
}
function seperator(){
    if(document.getElementById('input').innerText.includes("+")){
        operator = "+";
        return document.getElementById('input').innerText.split("+");
    }
    else if(document.getElementById('input').innerText.includes("-")){
        operator = "-";
        return document.getElementById('input').innerText.split("-");
    }
    else if(document.getElementById('input').innerText.includes("/")){
        operator = "/";
        return document.getElementById('input').innerText.split("/");
    }
    else if(document.getElementById('input').innerText.includes("x")){
        operator = "x";
        return document.getElementById('input').innerText.split("x");
    }
    else if(document.getElementById("input").innerText == "ANS"){
        return 1;
    }
    else{
        return 0;
    }
}
function cal(val1,val2,op){
    switch(op){
        case "x": return (val1*1) * (val2*1);
        case "/": return (val1*1) / (val2*1);
        case "+": return (val1*1) + (val2*1);
        case "-": return (val1*1) - (val2*1);
    }
}