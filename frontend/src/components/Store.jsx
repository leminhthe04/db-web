export default function Store({orderList, storeName, storeRevenue, orderCount}) {

    return (
        <>
            <div className="store1-name font-bold text-lg ">
                <div className="inline-block bg-gray-200 p-2">{storeName}</div>
                <span className="font-sm italic font-normal px-2"> Doanh thu: {storeRevenue} <span className="inline-block w-2"></span> | <span className="inline-block w-2"></span>  {orderCount} đơn hàng</span>
            </div>
            <table className="w-10/12 justify-start items-start text-center text-bold text-xl mx-auto">
                <thead>
                    <tr className="h-14 bg-purple-1 border rounded-e-sm">
                        <td className="w-1/12">STT</td>
                        <td className="w-1/12">Mã đơn hàng</td>
                        <td className="w-1/12">Doanh thu</td>
                        <td className="w-1/12">Thời điểm</td>
                    </tr>
                </thead>
                <tbody>
                    { orderList.map((order, index) => {
                        return (
                            <tr className="h-14 border rounded-e-sm">
                                <td className="w-1/12">{index +1 }</td>
                                <td className="w-1/12">{order.order_id}</td>
                                <td className="w-1/12">{order.order_revenue}</td>
                                <td className="w-1/12">{order.packing_date}</td>
                            </tr>
                        )
                    })}
                </tbody>
            </table>
        </>
    )
}