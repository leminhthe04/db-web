import { useEffect, useState } from "react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import CustomerPie from "../components/CustomerPie";
import { DayPicker } from "react-day-picker";
import { useParams } from "react-router-dom";
import axios from "axios";
import Store from "../components/Store";



export default function SellerDetail() {
    const {sellerID} = useParams();
    const [sellerName, setSellerlName] = useState(null);
    const [sellerPhone, setSellerPhone] = useState(null);
    const [sellerEmail, setSellerEmail] = useState(null);
    const [revenue, setRevenue] = useState(null); 
    const [totalOrder, setTotalOrder] = useState(null);
    const [totalStore, setTotalStore] = useState(null);
    const [startYear, setStartYear] = useState(null);  
    const [startMonth, setStartMonth] = useState(null); 
    const [startDay, setStartDay] = useState(null);

    const [endYear, setEndYear] = useState(null);   
    const [endMonth, setEndMonth] = useState(null);
    const [endDay, setEndDay] = useState(null);

    const [storeList, setStoreList] = useState([]); 






    useEffect(() => {
            axios.post(`http://localhost/api/seller/statistic/${sellerID}`, {
                from: "1990-01-01",
                to: "2025-01-01"
            })
            .then((response) => {
                const result = response.data.data;
                console.log(result);
                setSellerlName(result.seller_name);
                setSellerPhone(result.seller_phone);
                setSellerEmail(result.seller_email);
                setRevenue(result.seller_revenue); 
                setTotalStore(result.count_store);
                setTotalOrder(result.count_order);
                setStoreList(result.stores_statistic );

            })
            .catch((error) => {
                if (error.response) {
                    // alert(error.response.data.msg);
                } else {
                    console.error('Error:', error.message);
                }
            })
    }, [])
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

    function handleFilter() {
        const startTime = `${startYear}-${startMonth}-${startDay}`;
        const endTime  = `${endYear}-${endMonth}-${endDay}`;
        // if(!startDate || !endDate) {
        //     alert("Chưa chọn ngày");
        //     return;
        // }


        console.log("CHECK START DATE: ", startTime, endTime);

        axios.post(`http://localhost/api/seller/statistic/${sellerID}`, {
            from: startTime,
            to: endTime
        })
        .then((response) => {
            const result = response.data.data;
            console.log(result);
            setSellerlName(result.seller_name);
            setSellerPhone(result.seller_phone);
            setSellerEmail(result.seller_email);
            setRevenue(result.seller_revenue); 
            setTotalStore(result.count_store);
            setTotalOrder(result.count_order);
            setStoreList(result.stores_statistic );
        })
        .catch((error) => {
            if (error.response) {
                // alert(error.response.data.msg);
            } else {
                console.error('Error:', error.message);
            }
        })
    }

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
                                    {sellerName}
                                </div>
                            </div>
                            <div className="space-y-1">
                                <label htmlFor="name">Số điện thoại</label>
                                <div className="pl-2 bg-gray-100 rounded-ms p-1 text-gray-600">
                                    {/* {userDetail.email} */}
                                    {sellerPhone}
                                </div>
                            </div>
                            <div className="space-y-1">
                                <label htmlFor="name">Email</label>
                                <div className="pl-2 bg-gray-100 rounded-ms p-1 text-gray-600">
                                    {sellerEmail}
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
                                        {revenue}
                                    </div>
                                </div>
                                <div>
                                    <div className="text-lg"> Tổng đơn hàng </div>
                                    <div className="font-bold text-3xl text-right">
                                        {/* {new Intl.NumberFormat('vi-VN').format(userDetail.total_payment)} */}
                                        {totalOrder}
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

                    <div className="mr-40 flex justify-end space-x-40 ml-40">
                        <div>
                            <span>Ngày bắt đầu: </span>
                            <div  className="inline-block w-96 flex">
                                <span>
                                    <input placeholder="YYYY"
                                        value={startYear}
                                        onChange={(e) => setStartYear(e.target.value)}
                                    />
                                </span>/
                                <span>
                                    <input placeholder="MM"
                                        value={startMonth}
                                        onChange={(e) => setStartMonth(e.target.value)}
                                    />
                                </span>/
                                <span>
                                    <input placeholder="DD"
                                        value={startDay}
                                        onChange={(e) => setStartDay(e.target.value)}
                                    />
                                </span>
                            </div>
                            {/* <button
                                onClick={() => setShowStartPicker((prev) => !prev)}
                                className="px-4 py-2 bg-blue-500 text-white rounded"
                            >
                                {startDate ? startDate.toISOString().split('T')[0] : 'Chọn ngày'}
                            </button>

                            {showStartPicker && (
                                <div className="absolute bg-white shadow-lg p-4 rounded">
                                    <DayPicker
                                        mode="single"
                                        selected={startDate}
                                        onSelect={handleStartDate}
                                    />
                                </div>
                            )} */}
                        </div>
                        <div className="" >
                             <span>Ngày kết thúc: </span>
                             <div className="inline-block w-96 flex">
                                <span className="">
                                    <input placeholder="YYYY"
                                        value={endYear}
                                        onChange={(e) => setEndYear(e.target.value)}
                                    />
                                </span>/
                                <span>
                                    <input placeholder="MM"
                                        value={endMonth}
                                        onChange={(e) => setEndMonth(e.target.value)}
                                    />
                                </span>/
                                <span>
                                    <input placeholder="DD"
                                        value={endDay}
                                        onChange={(e) => setEndDay(e.target.value)}
                                    />
                                </span>
                            </div>
                            {/* <button
                                onClick={() => setShowEndPicker((prev) => !prev)}
                                className="px-4 py-2 bg-blue-500 text-white rounded"
                            >
                                {endDate ? endDate.toISOString().split('T')[0] : 'Chọn ngày'}
                            </button>

                            {showEndPicker && (
                                <div className="absolute bg-white shadow-lg p-4 rounded">
                                    <DayPicker
                                        mode="single"
                                        selected={endDate}
                                        onSelect={handleEndDate}
                                    />
                                </div>
                            )} */}
                        </div>
                    </div>
                    <div className="flex justify-end mt-4"
                        onClick={handleFilter}
                    >
                        <button className="bg-blue-500 text-white px-4 py-2 rounded-lg mr-40">Xem thống kê</button>
                    </div>
                            
                    {/* e({orderList, storeName, storeRevenue, orderCount}) */}
                    {storeList.map((store, index) => (
                        <div className="store-1 w-11/12 mx-auto mt-6">
                            <Store storeName={store.store_name} orderCount={store.count_order} storeRevenue={store.revenue} orderList={store.orders} />
                        </div>
                    ))}




                </div>

            </main>

            {/* <Footer /> */}
        </>

    )
}