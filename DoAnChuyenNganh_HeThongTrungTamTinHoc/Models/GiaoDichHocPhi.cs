//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DoAnChuyenNganh_HeThongTrungTamTinHoc.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class GiaoDichHocPhi
    {
        public int MaGD { get; set; }
        public string MaHV { get; set; }
        public string MaKH { get; set; }
        public string MaLH { get; set; }
        public Nullable<int> MaPT { get; set; }
        public Nullable<System.DateTime> NgayGD { get; set; }
        public Nullable<double> SoTien { get; set; }
        public string SoDT { get; set; }
        public string Email { get; set; }
        public string TrangThai { get; set; }
    
        public virtual HocVien HocVien { get; set; }
        public virtual KhoaHoc KhoaHoc { get; set; }
        public virtual LopHoc LopHoc { get; set; }
        public virtual PhuongThucThanhToan PhuongThucThanhToan { get; set; }
    }
}
