export default function Store({orderList, storeData}) {

    return (
        <>
            <div className="store1-name font-bold text-lg ">
                <div className="inline-block bg-gray-200 p-2">Cửa hàng iTalic</div>
                <span className="font-sm italic font-normal px-2">11, Đường Lý Thường Kiệt, Quận 10, TP.HCM</span>
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
                    {Array.from({ length: 2 }, (_, i) => (
                        <tr className="h-14 border rounded-e-sm">
                             <td className="w-1/12">{i+1}</td>
                            <td className="w-1/12">#001</td>
                            <td className="w-1/12">100.000 VND</td>
                            <td className="w-1/12">12-02-1004</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </>
    )
}