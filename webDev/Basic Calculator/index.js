function clicked(num){
    let str = document.getElementById('input').innerText;
    let chars = str.split("");
    let prev = "";
    let next = "";
    let op = "";
    if(str.length<41){
        switch(num){
            case "AC": document.getElementById('input').innerHTML = "";
            break;
            case "DEL": chars.pop(); let str1= chars.join(""); document.getElementById('input').innerHTML = str1;
            break;
            case "ANS": document.getElementById('input').innerHTML = prev;
            break;
            case "+": prev = document.getElementById('input').innerText; op = "+";document.getElementById('input').innerHTML="";
            break;
            case "-": prev = document.getElementById('input').innerText; op = "-";document.getElementById('input').innerHTML="";
            break;
            case "*": prev = document.getElementById('input').innerText; op = "*";document.getElementById('input').innerHTML="";
            break;
            case "/": prev = document.getElementById('input').innerText; op = "/";document.getElementById('input').innerHTML="";
            break;
            case "=": next = document.getElementById('input').innerText; 
            switch(op){
                case "*":document.getElementById('input').innerHTML = prev.concat(op).concat(next);document.getElementById('output').innerHTML = prev*next;
                break;
                case "+":document.getElementById('input').innerHTML = prev.concat(op).concat(next);document.getElementById('output').innerHTML = prev+next;
                break;
                case "-":document.getElementById('input').innerHTML = prev.concat(op).concat(next);document.getElementById('output').innerHTML = prev-next;
                break;
                case "/":document.getElementById('input').innerHTML = prev.concat(op).concat(next);document.getElementById('output').innerHTML = prev/next;
                break;
            }
            ;
            break;
            default:document.getElementById('input').innerHTML = document.getElementById('input').innerText.concat(num);
            break;
        }
    }
    else{
         
    }
}