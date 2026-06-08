import React, { useEffect, useState } from 'react';
import '../../styles/common.css';
import { Navigate, useNavigate, useParams } from 'react-router-dom';
import requestApi from '../../util/api/requestApi';
import Swal from 'sweetalert2';

const CtrtDetail = () => {
  const { RENT_CTRT_NO } = useParams();
  const [detail, setDetail] = useState(null);
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setDetail(prev => ({ ...prev, [name]: value }));
  };

  useEffect(() => {
    const fetchCtrtDetails = async () => {
      try {
        const response = await requestApi.get(`/api/react/adm/ctrt/detail/${RENT_CTRT_NO}`);
        if (response.data && response.data.ctrtDetail) {
          setDetail(response.data.ctrtDetail);
        } else {
          console.error("서버 응답이 배열 형식이 아닙니다: ", response.data);
          setDetail(null);
        }
      } catch (error) {
        console.error("데이터 로드 실패 : ", error);
        setDetail(null);
      }
    };

    fetchCtrtDetails();
  }, []);

  // 폼 제출 핸들러 (PUT 요청)
  const handleSubmit = async (e) => {
    e.preventDefault();

    // 1. SweetAlert2 컨펌 창 띄우기
    const result = await Swal.fire({
      title: '저장하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#226046',
      cancelButtonColor: '#d33',
      confirmButtonText: '저장',
      cancelButtonText: '취소'
    });

    // 2. 취소를 눌렀다면 여기서 종료
    if (!result.isConfirmed) return;

    // 1. 전송할 데이터를 위한 깊은 복사 (원본 detail 객체 보호)
    const submitData = { ...detail };

    // 2. 금액 관련 필드들의 콤마 제거
    const amountFields = ['DPST_AMT', 'CTRT_AMT', 'MID_PAY_AMT', 'BAL_AMT', 'MTHLY_RENT_AMT'];
    amountFields.forEach(field => {
      if (submitData[field]) {
        // 입력값에 콤마가 포함되어 있다면 제거 (문자열 타입 처리)
        submitData[field] = String(submitData[field]).replace(/,/g, '');
      }
    });

    try {
      // 3. 콤마가 제거된 submitData를 전송
      const response = await requestApi.put(`/api/react/adm/ctrt/update/${RENT_CTRT_NO}`, submitData);

      if (response.status === 200) {
        Swal.fire({
          icon: 'success'
          , title: '성공'
          , text: "성공적으로 수정되었습니다."
          , confirmButtonText: '확인'
        }).then((result) => {
          if (result.isConfirmed) {
            navigate('/adm/ctrt');
          }
        });
      }
    } catch (error) {
      console.error("수정 요청 실패 : ", error);
      Swal.fire({
        icon: 'error'
        , title: '실패'
        , text: "수정 중 오류가 발생했습니다."
        , confirmButtonColor: '#d33'
        , confirmButtonText: '확인'
      })
    }
  };

  const getCtrtSttsName = (code) => {
    // 코드와 한글 이름을 연결한 맵(Map) 객체
    const statusMap = {
      'PENDING': '승인대기',
      'APPROVED': '승인',
      'CANCEL': '취소',
      'REJECT': '반려',
      'TERMINATED': '중도해지',
      'EXPIRED': '계약만료'
    };

    return statusMap[code] || '상태없음';
  };

  console.log(detail?.HO_NO);
  const getHo = (hoNo) => {
    if (!hoNo) return [];

    return hoNo.split('_');
  }

  const hoInfo = getHo(detail?.HO_NO)

  if (!detail) return <div className="content-wrapper">로딩 중...</div>;

  let docs = detail.docList;

  return (
    <div className="content-wrapper" >
      <div className="form-max-container" style={{ maxWidth: '1440px', width: '100%' }}>

        <form onSubmit={handleSubmit}>

          {/* 타이틀 영역 */}
          <div className="page-header" style={{ marginBottom: '10px' }}>
            <div style={{ marginBottom: '0px' }}>
              <h2 className="page-title" style={{ fontSize: '24px', marginBottom: '0px' }}>계약 상세 정보</h2>
              <p className="page-subtitle" style={{ fontSize: '13px', margin: '0px' }}>Contract Detail</p>
            </div>
            <div className="header-actions">
              <button
                type="button"
                className="btn-outline"
                onClick={() => navigate('/adm/ctrt')}
                style={{ padding: '6px 12px', fontSize: '13px' }}
              >
                목록으로
              </button>
              <button
                type="submit"
                className="btn-primary"
                style={{ padding: '6px 12px', fontSize: '13px' }}
              >
                수정하기
              </button>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '16px' }}>

            {/* 1. 계약 기본 정보 (상단 전체 너비) */}
            <div className="compact-card" style={{ gridColumn: '1 / -1' }}>
              <h3 className="compact-card-title">
                계약 기본 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: '12px' }}>
                <div className="compact-input-group">
                  <label>계약 번호</label>
                  <input type="text" value={detail.RENT_CTRT_NO} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>계약 상태</label>
                  <select
                    name="CTRT_STTS_CD"
                    value={detail.CTRT_STTS_CD}
                    onChange={handleChange}
                    className="font-bold text-primary-color bg-white-force"
                  >
                    <option value="PENDING">승인대기</option>
                    <option value="APPROVED">승인</option>
                    <option value="CANCEL">취소</option>
                    <option value="REJECT">반려</option>
                    <option value="TERMINATED">중도해지</option>
                    <option value="EXPIRED">만료</option>
                  </select>
                </div>
                <div className="compact-input-group">
                  <label>계약 승인일</label>
                  <input type="text" value={detail.CTRT_APRV_DT
                    ? new Date(detail.CTRT_APRV_DT).toLocaleDateString('ko-KR', {
                      year: '2-digit', month: '2-digit', day: '2-digit'
                    }).replace(/\.$/, '')
                    : ''} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임대매물번호</label>
                  <input type="text" value={detail.RENT_LSTG_NO} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>담당자 번호</label>
                  <input type="text"
                    value={`${detail.CTRT_MGR_USER_NO}`}
                    name='CTRT_MGR_USER_NO'
                    onChange={handleChange}
                    className="font-bold text-primary-color bg-white-force"
                  />
                </div>
                <div className="compact-input-group">
                  <label>담당자 이름</label>
                  <input type="text"
                    value={`${detail.CTRT_MGR_USER_NM}`}
                    name='CTRT_MGR_USER_NM'
                    className="bg-gray-disabled" readOnly />
                </div>
              </div>
            </div>

            {/* 좌측 영역 (매물/임차인 + 특약/서류) */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div className="compact-card">
                <h3 className="compact-card-title">
                  매물 및 임차인 정보
                </h3>
                <div className="compact-input-group" >
                  <label>아파트 정보</label>
                  <input type="text" value={`${detail.APT_CMPLEX_NM} ${hoInfo[1]}동 ${hoInfo[2]}호`} className="bg-gray-disabled" readOnly />
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                  <div className="compact-input-group" >
                    <label>타입</label>
                    <input type="text" value={detail.TY_NM ? `${detail.TY_NM} ${detail.EXCLUSIVE_SIZE}㎡` : ''} className="bg-gray-disabled" readOnly />
                  </div>
                  <div className="compact-input-group">
                    <label>임차인 이름</label>
                    <input type="text" value={detail.USER_NM ? `${detail.USER_NM}` : `${detail.RENTOR_NM}`} className="bg-gray-disabled" readOnly />
                  </div>
                  <div className="compact-input-group">
                    <label>임차인 ID (번호)</label>
                    <input type="text" value={detail.USER_ID ? `${detail.USER_ID} (${detail.USER_NO})` : ''} className="bg-gray-disabled" readOnly />
                  </div>
                </div>
              </div>

              <div className="compact-card" style={{ flex: 1 }}>
                <h3 className="compact-card-title">
                  특약 및 서류
                </h3>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  <div className="compact-input-group">
                    <label>특약 사항</label>
                    <textarea
                      name="SPCL_STPLTN_CN"
                      style={{ resize: 'none', height: '60px' }}
                      value={detail.SPCL_STPLTN_CN || ''}
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <p className="upload-main-text" style={{ fontSize: '13px', margin: '0 0 2px 0' }}>첨부 서류 {docs?.length || 0}건</p>
                    {
                      docs?.map((doc, idx) => {
                        return (
                          <div key={idx}>
                            <span className='text-small'>{idx + 1}.&nbsp;</span>
                            <a href={`/file/download/${doc.googleId}`} rel='noopener noreferrer'>
                              <span className='text-small'>{doc.fileOgName}</span>
                            </a>
                            <br />
                          </div>
                        )
                      })
                    }
                  </div>
                </div>
              </div>
            </div>

            {/* 우측 영역 (금액 + 일정/관계자) */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>

              <div className="compact-card">
                <h3 className="compact-card-title">
                  계약 금액 정보(원&#8361;)
                </h3>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                  <div className="compact-input-group" >
                    <label>임대 유형</label>
                    <input type="text" value={(detail.RENT_TYPE_CD === 'JS' ? '전세' : '월세')} className="bg-gray-disabled" readOnly />
                  </div>
                  <div className="compact-input-group">
                    <label>보증금</label>
                    <input type="text" value={detail.DPST_AMT != null ? `${detail.DPST_AMT.toLocaleString()}` : ''}
                      name='DPST_AMT'
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>계약금</label>
                    <input
                      type="text"
                      value={detail.CTRT_AMT != null ? detail.CTRT_AMT.toLocaleString() : ''}
                      name="CTRT_AMT"
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>중도금</label>
                    <input type="text" value={detail.MID_PAY_AMT != null ? `${detail.MID_PAY_AMT.toLocaleString()}` : ''}
                      name='MID_PAY_AMT'
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>잔금</label>
                    <input type="text" value={detail.BAL_AMT != null ? `${detail.BAL_AMT.toLocaleString()}` : ''}
                      name='BAL_AMT'
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  {/* 월세 입력칸: RENT_TYPE_CD가 'JS(전세)'가 아닐 때만 출력 */}
                  {detail.RENT_TYPE_CD !== 'JS' && (
                    <div className="compact-input-group">
                      <label>월세</label>
                      <input type="text" value={detail.MTHLY_RENT_AMT != null ? `${detail.MTHLY_RENT_AMT.toLocaleString()}` : ''}
                        name='MTHLY_RENT_AMT'
                        onChange={handleChange}
                        className="font-bold text-primary-color bg-white-force"
                      />
                    </div>
                  )}
                </div>
              </div>

              <div className="compact-card" style={{ flex: 1 }}>
                <h3 className="compact-card-title">
                  일정 및 관계자 정보
                </h3>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '12px' }}>
                  <div className="compact-input-group">
                    <label>입주 예정일</label>
                    <input
                      type="date"
                      name="MVIN_DT"
                      // 값이 있으면 문자열(YYYY-MM-DD)로 전달, 없으면 빈 문자열
                      value={detail.MVIN_DT ? detail.MVIN_DT.substring(0, 10) : ''}
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>퇴거 예정일</label>
                    <input
                      type="date"
                      name="MVOUT_DT"
                      value={detail.MVOUT_DT ? detail.MVOUT_DT.substring(0, 10) : ''}
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>퇴거일</label>
                    <input
                      type="date"
                      name="MVOUT_CMPL_DT"
                      value={detail.MVOUT_CMPL_DT ? detail.MVOUT_CMPL_DT.substring(0, 10) : ''}
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                  <div className="compact-input-group">
                    <label>대리인</label>
                    <input
                      type="text"
                      value={detail.AGNT_NM || ''}
                      name='AGNT_NM'
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                  <div className="compact-input-group">
                    <label>대리인 전화번호</label>
                    <input
                      type="text"
                      value={detail.AGNT_TELNO || ''}
                      name='AGNT_TELNO'
                      onChange={handleChange}
                      className="font-bold text-primary-color bg-white-force"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CtrtDetail;