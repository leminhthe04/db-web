import { useState, useEffect } from "react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import axios from "axios";
import Pagination from "../components/Pagination";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faMagnifyingGlass } from "@fortawesome/free-solid-svg-icons";

// const userData = [{
//     "uid": "2212254",
//     "username": "ngoc",
//     "upassword": "123456",
//     "fname": "Ngọc",
//     "lname": "Huỳnh",
//     "email": "ngoc@gmail.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": "083304003958"
// },
// {
//     "uid": "2212254",
//     "username": "ngoc",
//     "upassword": "123456",
//     "fname": "Ngọc",
//     "lname": "Huỳnh",
//     "email": "ngoc@gmail.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": "083304003958"
// },
// {
//     "uid": "2212254",
//     "username": "ngoc",
//     "upassword": "123456",
//     "fname": "Ngọc",
//     "lname": "Huỳnh",
//     "email": "ngoc@gmail.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": "083304003958"
// }, {
//     "uid": "2212254",
//     "username": "ngoc",
//     "upassword": "123456",
//     "fname": "Ngọc",
//     "lname": "Huỳnh",
//     "email": "ngoc@gmail.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": "083304003958"
// },
// {
//     "uid": "323322afdsfa",
//     "username": "anhthu",
//     "upassword": "12345",
//     "fname": "Bui",
//     "lname": "Thu",
//     "email": "thu@gmail.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "1999-12-31T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// },
// {
//     "uid": "0180b798-3e88-4ff4-978a-9e402df8ca89",
//     "username": "thu",
//     "upassword": "$2a$12$SiNbtnQEloPKFV4B/QWpxe/UZu3dEbQXzbycJLaLMjQ3v.WNxaYwu",
//     "fname": "Thu",
//     "lname": "Bui",
//     "email": "thu@gmai.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// },
// {
//     "uid": "0180b798-3e88-4ff4-978a-9e402df8ca89",
//     "username": "thu",
//     "upassword": "$2a$12$SiNbtnQEloPKFV4B/QWpxe/UZu3dEbQXzbycJLaLMjQ3v.WNxaYwu",
//     "fname": "Thu",
//     "lname": "Bui",
//     "email": "thu@gmai.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// },
// {
//     "uid": "0180b798-3e88-4ff4-978a-9e402df8ca89",
//     "username": "thu",
//     "upassword": "$2a$12$SiNbtnQEloPKFV4B/QWpxe/UZu3dEbQXzbycJLaLMjQ3v.WNxaYwu",
//     "fname": "Thu",
//     "lname": "Bui",
//     "email": "thu@gmai.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// },
// {
//     "uid": "0180b798-3e88-4ff4-978a-9e402df8ca89",
//     "username": "thu",
//     "upassword": "$2a$12$SiNbtnQEloPKFV4B/QWpxe/UZu3dEbQXzbycJLaLMjQ3v.WNxaYwu",
//     "fname": "Thu",
//     "lname": "Bui",
//     "email": "thu@gmai.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// },
// {
//     "uid": "0180b798-3e88-4ff4-978a-9e402df8ca89",
//     "username": "thu",
//     "upassword": "$2a$12$SiNbtnQEloPKFV4B/QWpxe/UZu3dEbQXzbycJLaLMjQ3v.WNxaYwu",
//     "fname": "Thu",
//     "lname": "Bui",
//     "email": "thu@gmai.com",
//     "gender": "female",
//     "usertype": "customer",
//     "ranking": "silver",
//     "birthday": "2004-07-02T17:00:00.000Z",
//     "total_payment": 0,
//     "id_no": null
// }

// ]

export default function UsersManagement() {
    const [totalUser, setTotalUser] = useState(null);
    const [userData, setUserData] = useState({});
    const [page, setTotalPage] = useState(null);
    const [currentPage, setCurrentPage] = useState(0);

    // useEffect(() => {
    //     axios.get("http://localhost:8000/api/user/users?limit=10")
    //         .then((response) => {
    //             const userData = response.data.data;
    //             console.log(userData);
    //             setUserData(userData);
    //             setTotalUser(response.data[totalUser]);
    //             setTotalPage(response.data["totalPage"]);
    //             console.log(page, currentPage)
    //         })
    //         .catch((err) => {
    //             alert(err.msg);
    //         });
    // }, [])


    function handlePageClick(pageNum) {
        const index = Number(pageNum);
        axios.get(`http://localhost:8000/api/user/users?page=${index}&limit=10`,)
            .then((response) => {
                console.log(response);
                setCurrentPage(pageNum)
                const users = response.data.data;
                // console.log(JSON.stringify(products));
                setUserData(users);
            })
            .catch((error) => {
                if (error.response) {
                    alert(error.response.data.msg);
                } else {
                    console.error('Error:', error.message);
                }
            })
    }

    return (
        <div className="flex flex-col min-h-screen w-full">
            <Header />
            <div className="h-10"></div>
            <main className="flex-grow bg-purple-2 w-full">
                <div className="m-4 pl-20">
                    <span className="text-gray-600">Shop / </span>
                    <span className="font-medium">Seller Management</span>
                </div>

                <div className="bg-white w-10/12 min-h-96 m-auto mt-10 rounded-3xl">
                    <div className="font-bold text-lg px-6 pt-6">Tất cả người bán</div>


                    <div className="w-10/12 m-auto mt-6" style={{ height: "540px" }} >
                        <table className="border-none w-full" >
                            <thead>
                                <tr className="w-full h-6 font-bold text-base">
                                    <td className="w-1/6 text-center ">STT</td>
                                    <td className="w-1/6 ">Tên người bán</td>
                                    <td className="w-1/6 ">Số điện thoại</td>
                                    <td className="w-1/6 ">Email</td>
                                    <td className="w-1/6">Thông tin</td>

                                </tr>
                                <tr className="h-2 border-b border-zinc-300 my-10"></tr>

                            </thead>
                            <tbody>
                                {Array.from({ length: 10 }, (_, i) => (
                                    <tr className="h-14 rounded-e-sm">
                                        <td className="w-1/6 text-center ">{i+1}</td>
                                        <td className="w-1/6 ">Bao Ngoc</td>
                                        <td className="w-1/6 ">0918199992</td>
                                        <td className="w-1/6 ">Email</td>
                                        <td className="w-1/6">
                                            <a href="" className=" border-2 border-green-500 px-3 rounded-md bg-green-100 font-semibold text-green-700 py-1">Chi tiết</a>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>


                    </div>
                    <div className="h-16 flex flex-end justify-end items-end">
                        <div className="mb-4 mr-10">
                            <div className="flex justify-end mr-20">
                                {/* <Pagination /> */}
                                {Array.from({ length: page }, (_, i) => (
                                    <button
                                        key={i}
                                        onClick={() => handlePageClick(i)} // Pass the page number to the handler
                                        className={`px-3 py-1 mx-1 hover:bg-blue-300 ${currentPage === i ? "bg-blue-500 text-white" : "bg-gray-200"
                                            } rounded`}
                                    >
                                        {i + 1}
                                    </button>
                                ))}
                            </div>
                        </div>
                    </div>
                </div>




                <div className="h-20">

                </div>
            </main >

            <div className="h-10"></div>
        </div >
    )

}