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

export function HeaderWithButtons (props: { link1: any; link2: any; }){
  const link1 = props.link1;
  const link2 = props.link2;

  return (
    <div id="page-top">
      <h1>
        <span style={{fontStyle:'italic',letterSpacing:'0.13em',}}>C<span style={{color:'#FF9FA1'}}>o</span>nf</span><span style={{fontWeight:'lighter'}}>Plus</span>
      </h1>
      <div id="top-btns">
        <Link href ={ link1 }><button>Schedule</button></Link>
        <Link href ={ link2 }><button>Logout</button></Link>  
      </div>
      </div>
  )
}

export const Styles = {
  input:  `focus:outline-none
           focus:border-purple-800 
           border-y-4 w-3/4 p-2 
           border-purple-400 rounded 
           transition-colors my-4 
           font-segoelight text-sm 
           font-extralight text-slate-700 
           tracking-normal hover:border-purple-600 
           bg-white text-center`,

  input2:  `focus:outline-none
           transition-colors my-4 
           font-segoelight text-sm 
           font-extralight text-slate-700 
           tracking-normal hover:border-purple-600 
           bg-white text-center`,

  label:  `font-segoe text-lg font-semibold`,

  label2: `font-segoe text-base font-normal`,

  button: `border-4 border-purple-400 rounded-3xl
           text-purple-800 hover:border-4
           hover:border-purple-600 hover:text-slate-700
           hover:bg-white hover:font-normal transition-colors
           font-segoelight text-sm font-medium tracking-normal
           w-1/6 bg-pink-100 p-2 my-4`,
  
  field:  `border-4 rounded-3xl`,

  legend: `font-segoelight text-medium font-light ml-0 mx-4 px-4`,

  label3: `font-segoe text-base font-normal mx-4 mb-6`
}
