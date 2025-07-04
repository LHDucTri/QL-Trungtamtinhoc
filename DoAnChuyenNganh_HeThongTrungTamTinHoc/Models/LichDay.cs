﻿//------------------------------------------------------------------------------
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
    using System.ComponentModel.DataAnnotations;

    public partial class LichDay
    {
        public string MaLichDay { get; set; }
        [Required(ErrorMessage = " Bạn phải nhập giáo viên ")]
        public string MaGV { get; set; }

        [Required(ErrorMessage = " Bạn phải nhập lớp học ")]
        public string MaLH { get; set; }

        [Required(ErrorMessage = " Bạn phải nhập ngày dạy ")]
        public System.DateTime NgayDay { get; set; }

        [Required(ErrorMessage = " Bạn phải nhập giờ bắt đầu ")]
        public System.TimeSpan GioBatDau { get; set; }

        [Required(ErrorMessage = " Bạn phải nhập giờ kết thúc ")]
        public System.TimeSpan GioKetThuc { get; set; }


        public virtual GiaoVien GiaoVien { get; set; }
        public virtual LopHoc LopHoc { get; set; }
    }
}
