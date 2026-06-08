import { Outlet, useNavigate } from 'react-router-dom';

function Ann() {
    const navigate = useNavigate();
    const move = () =>{
        navigate("/adm/ann/register");
        console.log("버튼 테스트");
    }

    return (
        <>
            <div>Ann</div>
            <button onClick={move}>이동</button>
            <Outlet/>
        </>
    )
}

export default Ann