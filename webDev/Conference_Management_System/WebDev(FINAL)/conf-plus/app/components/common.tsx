import Link from "next/link";

export function Header (){
    return (
    <div id="page-top">
      <h1>
        <span style={{fontStyle:'italic',letterSpacing:'0.13em',}}>C<span style={{color:'#FF9FA1'}}>o</span>nf</span><span style={{fontWeight:'lighter'}}>Plus</span>
      </h1>
    </div>
    );
}

export function HeaderWithButtons (){
  return (
    <div id="page-top">
      <h1>
        <span style={{fontStyle:'italic',letterSpacing:'0.13em',}}>C<span style={{color:'#FF9FA1'}}>o</span>nf</span><span style={{fontWeight:'lighter'}}>Plus</span>
      </h1>
      <div id="top-btns">
        <Link href ="/actions/display"><button className={Styles.button2}>Schedule</button></Link>
        <Link href ="/actions/stats"><button className={Styles.button2}>Stats</button></Link>
        <Link href ="/"><button className={Styles.button2} onClick={()=>{
          localStorage.removeItem("user");
        }}>Logout</button></Link>  
      </div>
      </div>
  )
}

export function HeaderWithButtons2 (){
  return (
    <div id="page-top">
      <h1>
        <span style={{fontStyle:'italic',letterSpacing:'0.13em',}}>C<span style={{color:'#FF9FA1'}}>o</span>nf</span><span style={{fontWeight:'lighter'}}>Plus</span>
      </h1>
      <div id="top-btns">
        <Link href ="/actions"><button className={Styles.button2}>Return</button></Link>
        <Link href ="/actions/stats"><button className={Styles.button2}>Stats</button></Link>
        <Link href ="/"><button className={Styles.button2} onClick={()=>{
          localStorage.removeItem("user");
        }}>Logout</button></Link>
      </div>
      </div>
  )
}

export function HeaderWithButtons3 (){
  return (
    <div id="page-top">
      <h1>
        <span style={{fontStyle:'italic',letterSpacing:'0.13em',}}>C<span style={{color:'#FF9FA1'}}>o</span>nf</span><span style={{fontWeight:'lighter'}}>Plus</span>
      </h1>
      <div id="top-btns">
        <Link href ="/actions/display"><button className={Styles.button2}>Schedule</button></Link>
        <Link href ="/actions/"><button className={Styles.button2}>Return</button></Link>
        <Link href ="/"><button className={Styles.button2} onClick={()=>{
          localStorage.removeItem("user");
        }}>Logout</button></Link>
      </div>
      </div>
  )
}

export const Styles = {
  input:  `focus:outline-none
           focus:border-purple-800 
           border-y-4 border-x-0 w-3/4 p-2 
           border-purple-400 rounded 
           transition-colors my-4 
           font-segoe text-sm 
           font-normal text-slate-700 
           tracking-normal hover:border-purple-600 
           bg-white text-center`,

  input2:  `focus:outline-none
           transition-colors my-4 
           font-segoe text-sm 
           font-normal text-slate-700 
           tracking-normal hover:border-purple-600 
           bg-white text-center`,
  
  input3: `focus:outline-none
           border-y-4 border-x-0 w-100 p-2 
           border-gray-400 rounded 
           transition-colors my-4 
           font-segoe text-sm 
           font-normal text-slate-700 
           tracking-normal
           bg-white text-center`,

  input4:  `focus:outline-none
           focus:border-purple-800 
           border-y-4 border-x-0 w-100 p-2 
           border-purple-400 rounded 
           transition-colors my-4 
           font-segoe text-sm 
           font-normal text-slate-700 
           tracking-normal hover:border-purple-600 
           bg-white text-center`,

  input5: `focus:outline-none
           select-none
           border-y-4 border-x-0 w-100 p-2 
           border-gray-400 rounded 
           transition-colors my-4 
           font-segoe text-lg 
           font-semibold text-slate-700 
           tracking-normal
           bg-white text-center`,

  label:  `font-segoe text-lg font-semibold select-none text-center `,

  label2: `font-segoe text-base font-normal select-none`,

  button: `border-4 border-purple-400 rounded-3xl
           text-purple-800 hover:border-4
           hover:border-purple-600 hover:text-slate-700
           hover:bg-white hover:font-normal transition-colors
           font-segoe text-sm font-normal tracking-normal
           w-1/6 bg-pink-100 p-2 my-4 text-center`,

  link:   `border-4 border-purple-400 rounded-3xl
           text-purple-800 hover:border-4
           hover:border-purple-600 hover:text-slate-700
           hover:bg-white hover:font-normal transition-colors
           font-segoe text-sm font-normal tracking-normal
           w-1/6 bg-pink-100 p-2 my-4 text-center`,

  button2: `border-4 border-purple-400 rounded-3xl
           text-purple-800 hover:border-4
           hover:border-purple-600 hover:text-slate-700
           hover:bg-white hover:font-normal transition-colors
           font-segoe text-sm font-normal tracking-normal
           w-1/2 bg-pink-100 p-2 my-4 text-center`,  
  
  field:  `border-4 rounded-3xl`,

  legend: `font-segoe text-light font-light ml-0 mx-4 px-4`,

  label3: `font-segoe text-sm font-light mx-4 mb-6 select-none`,

  text:   `font-seigo text-sm font-light text-slate-700 text-center`,

  text2:   `font-seigo text-normal font-light text-slate-700 text-center my-2`,
  
  text3:   `font-seigo text-normal font-bold text-slate-700 text-center my-2`,

  heading:`font-seigo text-4xl font-light text-purple-900 
           tracking-wider text-center mt-8 select-none`,
  
  form:   `align-center shadow-lg flex-col w-1/2`,
  
  card:   `p-4 max-w-max border-2 rounded-3xl border-purple-900 
           m-16 flex-col shadow-lg`
}
