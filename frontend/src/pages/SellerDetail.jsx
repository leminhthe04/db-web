import { useEffect, useState } from "react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import CustomerPie from "../components/CustomerPie";
import { DayPicker } from "react-day-picker";
import { useParams } from "react-router-dom";
import axios from "axios";
import Store from "../components/Store";



export default function SellerDetail() {
    // const {id} = useParams();
    // const [userDetail, setUserDetail] = useState({});
    // useEffect(() => {
    //     axios.get(`http://localhost:8000/api/user/get-detail/${id}`)
    //         .then((response) => {
    //             const detail = response.data.data;
    //             setUserDetail(detail);
    //         })
    //         .catch((error) => {
    //             if (error.response) {
    //                 alert(error.response.data.msg);
    //             } else {
    //                 console.error('Error:', error.message);
    //             }
    //         })
    // }, [])
    const [showStartPicker, setShowStartPicker] = useState(false);
    const [showEndPicker, setShowEndPicker] = useState(false);
    const [startDate, setStartDate] = useState(null); 
    const [endDate, setEndDate] = useState(null); 

    const handleStartDate = (date) => {
        setStartDate(date)
        setShowStartPicker(false);
    };

    const handleEndDate = (date) => {
        setEndDate(date); 
        setShowEndPicker(false);
    };

    return (
        <>
            <Header role="admin" page="user-manage" />

            <div className="m-4 mb-10 pl-6">
                <span className="text-grey-500">Seller / </span>
                <span className=" font-medium">Detail</span>
            </div>
            <main className="min-h-screen">
                <div className="info grid grid-cols-2">
                    <div className="col-1 ">
                        <div className="w-1/2 bg-white ml-20 space-y-2">
                            <div className="space-y-1">
                                <label htmlFor="name">Tên</label>
                                <div className="pl-2 bg-gray-100 rounded-ms p-1 text-gray-600">
                                    {/* {userDetail.lname + " " + userDetail.fname} */}
                                    Lê Minh Thế đáng ghét
                                </div>
                            </div>
                            <div className="space-y-1">
                                <label htmlFor="name">Số điện thoại</label>
                                <div className="pl-2 bg-gray-100 rounded-ms p-1 text-gray-600">
                                    {/* {userDetail.email} */}
                                    0942047349
                                </div>
                            </div>
                            <div className="space-y-1">
                                <label htmlFor="name">Email</label>
                                <div className="pl-2 bg-gray-100 rounded-ms p-1 text-gray-600">
                                    theleminh@gmail.com
                                </div>
                            </div>


                        </div>
                    </div>

                    <div className="col-1">
                        <div className="w-3/5 bg-purple-2 h-40 rounded-lg flex flex-row  items-center justify-between">
                            <div className="sta  p-4 flex flex-row justify-between items-center w-full mx-6">
                                <div>
                                    <div className="text-lg"> Tổng doanh thu </div>
                                    <div className="font-bold text-3xl">
                                        {/* {new Intl.NumberFormat('vi-VN').format(userDetail.total_payment)} */}
                                        10.000.000
                                    </div>
                                </div>
                                <div>
                                    <div className="text-lg"> Tổng đơn hàng </div>
                                    <div className="font-bold text-3xl text-right">
                                        {/* {new Intl.NumberFormat('vi-VN').format(userDetail.total_payment)} */}
                                        20
                                    </div>
                                </div>

                                {/* <div className="text-gray-700">12 đơn hàng</div> */}
                                {/* <div className="text-gray-700">Thẻ thành viên: {userDetail.ranking}</div> */}
                            </div>
                            {/* <div className="graph pr-4">
                                  <CustomerPie />       
                            </div> */}

                        </div>
                    </div>
                </div>
                <div>

                    <div className="mr-40 flex justify-end space-x-40">
                        <div>
                            <span>Ngày bắt đầu: </span>
                            <button
                                onClick={() => setShowStartPicker((prev) => !prev)}
                                className="px-4 py-2 bg-blue-500 text-white rounded"
                            >
                                {startDate ? startDate.toLocaleDateString('vi-VN') : 'Chọn ngày'}
                            </button>

                            {showStartPicker && (
                                <div className="absolute bg-white shadow-lg p-4 rounded">
                                    <DayPicker
                                        mode="single"
                                        selected={startDate}
                                        onSelect={handleStartDate}
                                    />
                                </div>
                            )}
                        </div>
                        <div>
                             <span>Ngày kết thúc: </span>
                            <button
                                onClick={() => setShowEndPicker((prev) => !prev)}
                                className="px-4 py-2 bg-blue-500 text-white rounded"
                            >
                                {endDate ? endDate.toLocaleDateString('vi-VN') : 'Chọn ngày'}
                            </button>

                            {showEndPicker && (
                                <div className="absolute bg-white shadow-lg p-4 rounded">
                                    <DayPicker
                                        mode="single"
                                        selected={endDate}
                                        onSelect={handleEndDate}
                                    />
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="store-1 w-11/12 mx-auto mt-6">
                        <Store />
                    </div>

                    <div className="store-1 w-11/12 mx-auto mt-6">
                        <Store />
                    </div>


                </div>

            </main>

            {/* <Footer /> */}
        </>

    )
}