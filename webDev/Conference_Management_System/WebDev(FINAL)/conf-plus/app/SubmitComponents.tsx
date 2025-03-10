import * as components from "@/app/common"

export function AuthorFields (props: any){

    const institutions = props.inst;

    console.log(institutions);

    return (
        <div id={props.id}>
            <label htmlFor={"fname-" + props.id}>
                First Name
                <input className={components.Styles.input} name={"fname-" + props.id} key={"fname-" + props.id} type="text" required />
            </label>
            <label htmlFor={"lname-" + props.id}>
                Last Name
                <input className={components.Styles.input} name={"lname-" + props.id} key={"lname-" + props.id} type="text" required />
            </label>
            <label  htmlFor={"email-" + props.id}>
                Email
                <input className={components.Styles.input} name={"email-" + props.id} key={"email-" + props.id} type="email" required />
            </label>
            <label htmlFor={"affil-" + props.id}>
                Affiliation
                <br/>
                <select className={components.Styles.input} name={"affil-" + props.id} key={"affil-" + props.id}>
                    {institutions.map((inst: string) =>(
                        <option value={inst}>{inst}</option>
                    ))}
                </select>
            </label>
            <hr className="border rounded"/>
        </div>
    )
  }