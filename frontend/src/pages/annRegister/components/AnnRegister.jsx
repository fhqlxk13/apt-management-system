import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';
import { Button } from '../../../components/common/Button';
import {
  getSido,
  getSigungu,
  getEmd,
  getAptList,
  toSelectOptions,
  getAptDetail,
  getSubmitDocTypes,
  insertAnn,
  getRentList,
} from '../../../util/api/announcement/annRegister';
import BasicInfoSection from './BasicInfoSection';
import AnnInfoSection from './AnnInfoSection';
import SupplyInfoSection from './SupplyInfoSection';
import SubmitDocSection from './SubmitDocSection';

/** 페이지 전용 레이아웃·표 (common.css 미수정) */
const ANN_PAGE_CSS = `
.content-wrapper.ann-register-full {
  max-width: none;
  width: 100%;
  min-height: calc(100vh - 120px);
}
.content-wrapper.ann-register-full .form-sections-stack {
  flex: 1 1 auto;
}
.ann-supply-table tbody tr {
  transition: none;
}
.ann-supply-table tbody tr:hover {
  background-color: transparent;
}
`;

/** insertAnn API 필드명과 동일 (ttl, cn, pblanc*, rcrt*) — mvinPrdDt는 전송 시 rcrtEndDt로 채움 */
const INITIAL_ANN_FORM = {
  ttl: '',
  cn: '',
  pblancBgngDt: '',
  pblancEndDt: '',
  rcrtBgngDt: '',
  rcrtEndDt: '',
};

/** YYYY-MM-DD 문자열 비교 (동일 포맷 전제) */
const ANN_LIST_PATH = '/adm/ann';

function showAnnAlert(icon, title, text) {
  return Swal.fire({
    icon,
    title,
    text,
    confirmButtonText: '확인',
  });
}

function assertDateOrder(pubS, pubE, rcS, rcE) {
  if (pubS > pubE) return '게시 시작일은 게시 종료일보다 앞서야 합니다.';
  if (rcS > rcE) return '모집 시작일은 모집 종료일보다 앞서야 합니다.';
  return null;
}

export default function AnnRegister() {
  const navigate = useNavigate();
  const [annForm, setAnnForm] = useState(() => {
    const saved = localStorage.getItem('annForm');
    return saved ? JSON.parse(saved) : INITIAL_ANN_FORM;
});

const setAnnField = (name, value) =>
    setAnnForm((prev) => {
        const next = { ...prev, [name]: value };
        localStorage.setItem('annForm', JSON.stringify(next));
        return next;
    });

  // ── 공급 정보: 지역·단지 cascade (SupplyInfoSection) ──
  const [sido, setsido] = useState('');
  const [sigungu, setsigungu] = useState('');
  const [emd, setemd] = useState('');
  const [aptCmplexNo, setAptCmplexNo] = useState('');
  const [addr, setAddr] = useState(''); // 단지 선택 시 aptDetail API로 채움 (읽기 전용)
  /** 단지별 GENERAL 매물 전체 (표시·페이징은 SupplyInfoSection에서 처리) */
  const [rentList, setRentList] = useState([]);
  /** 공고 등록 시 포함할 매물 번호 목록 → insertAnn.rentLstgNoList */
  const [selectedRentList, setSelectedRentList] = useState([]);

  // ── 공급 정보: select option 목록 (useEffect로 API 조회) ──
  const [sidoOptions, setSidoOptions] = useState([]);
  const [sigunguOptions, setSigunguOptions] = useState([]);
  const [emdOptions, setemdOptions] = useState([]);
  const [aptOptions, setAptOptions] = useState([]);

  // ── 공급 정보: 단지 상세 (aptDetail API → 호 타입 표) ──
  const [hoTyList, setHoTyList] = useState([]);

  // ── 제출 서류 (sbmsnDocList API · 조회 후 등록 시 sbmsnDoc 문자열로 저장) ──
  const [submitDocOptions, setSubmitDocOptions] = useState([]); // { value, label }[]

  const [submitting, setSubmitting] = useState(false);

  const resetEntireForm = () => {
    setAnnForm({ ...INITIAL_ANN_FORM });
    localStorage.removeItem('annForm');
    setsido('');
    setsigungu('');
    setemd('');
    setAptCmplexNo('');
    setAddr('');
    setRentList([]);
    setSelectedRentList([]);
    setHoTyList([]);
    setSubmitDocOptions([]);
  };

  // ─────────────────────────────────────────
  // 1. 시도 목록 조회
  // 페이지 진입 시 한 번만 실행
  // getSido() 호출 → setSidoOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    getSido()
      .then((data) => {
        console.log('시도 조회', data);
        setSidoOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('시도 조회 오류', e));
  }, []);

  // ─────────────────────────────────────────
  // 2. 시군구 목록 조회
  // sido 바뀔 때마다 실행
  // sido 없으면 setSigunguOptions([]) 초기화 후 return
  // getSigungu(sido) 호출 → setSigunguOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    if (!sido) {
      setSigunguOptions([]);
      return;
    }
    getSigungu(sido)
      .then((data) => {
        console.log('시군구 조회', sido, data);
        setSigunguOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('시군구 조회 오류', e));
  }, [sido]);

  // ─────────────────────────────────────────
  // 3. 읍면동 목록 조회
  // sigungu 바뀔 때마다 실행
  // sigungu 없으면 setemdOptions([]) 초기화 후 return
  // getEmd(sido, sigungu) 호출 → setemdOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    if (!sigungu) {
      setemdOptions([]);
      return;
    }
    getEmd(sido, sigungu)
      .then((data) => {
        console.log('읍면동 조회', sido, sigungu, data);
        setemdOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('읍면동 조회 오류', e));
  }, [sigungu, sido]);

  // ─────────────────────────────────────────
  // 4. 아파트 단지 조회
  // sido, sigungu, emd 바뀔 때마다 실행
  // sido, sigungu, emd 없으면 setAptOptions([]) 초기화 후 return
  // getAptList(sido, sigungu, emd) 호출 → setAptOptions
  // ─────────────────────────────────────────

  useEffect(() => {
    if (!sido) {
      setAptOptions([]);
      return;
    }
    getAptList(sido, sigungu, emd)
      .then((data) => {
        console.log('단지 조회', sido, sigungu, emd, data);
        setAptOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('단지 조회 오류', e));
  }, [sido, sigungu, emd]);

  // ─────────────────────────────────────────
  // 5. 단지 선택: 주소(aptDetail) + 매물 목록(rentList) 조회
  //    → SupplyInfoSection 테이블·체크·페이징
  //    → selectedRentList 변경 시 제출서류(sbmsnDocList) 연동
  // ─────────────────────────────────────────
  const handleAptChange = async (e) => {
    const aptCmplexNo = e.target.value;
    setAptCmplexNo(aptCmplexNo);
    setRentList([]);
    setSelectedRentList([]);
    setSubmitDocOptions([]);

    if (!aptCmplexNo) {
        setAddr('');
        return;
    }

    try {
        const data = await getAptDetail(aptCmplexNo);
        const rentData = await getRentList(aptCmplexNo);

        if (data.success) setAddr(data.dorojuso);
        if (rentData.success) setRentList(rentData.list ?? []);
    } catch (e) {
        console.error('단지 상세·매물 조회 오류', e);
    }
};

useEffect(() => {
  if (!selectedRentList || selectedRentList.length === 0) {
      setSubmitDocOptions([]);
      return;
  }
  getSubmitDocTypes(selectedRentList) // rentLstgNoList로 넘기기
      .then((docData) => {
          if (docData.success && Array.isArray(docData.list)) {
              const options = docData.list
                  .map((item) => ({
                      value: String(item.SBMSN_DOC_TY_CD ?? item.sbmsn_doc_ty_cd ?? ''),
                      label: String(item.CODE_NAME ?? item.code_name ?? ''),
                  }))
                  .filter((o) => o.value && o.label);
              setSubmitDocOptions(
                  Array.from(new Map(options.map((option) => [option.value, option])).values())
              );
          } else {
              setSubmitDocOptions([]);
          }
      })
      .catch((e) => console.error('제출서류 조회 오류', e));
}, [selectedRentList]);


  /** 후속 제출서류 매칭을 위해 sbmsn_doc에는 서류 타입 코드를 저장 */
  const buildSbmsnDoc = () =>
    submitDocOptions.map((o) => o.value).join(', ');

  /** DB insert용: 입주 예정일 컬럼은 모집 종료일과 동일하게 전달 */
  const getInsertPayload = () => ({
    ...annForm,
    ttl: annForm.ttl.trim(),
    cn: annForm.cn.trim(),
    aptCmplexNo,
    sbmsnDoc: buildSbmsnDoc(),
    mvinPrdDt: annForm.rcrtEndDt,
    rentLstgNoList: selectedRentList,
  });

  // ── 등록: insertAnn(getInsertPayload()) ──
  const handleSubmit = async () => {
    if (submitting) return;
    if (!annForm.ttl.trim()) {
      await showAnnAlert('warning', '입력 확인', '공고 제목을 입력하세요.');
      return;
    }
    if (!annForm.cn.trim()) {
      await showAnnAlert('warning', '입력 확인', '공고 내용을 입력하세요.');
      return;
    }
    if (!aptCmplexNo) {
      await showAnnAlert('warning', '입력 확인', '아파트 단지를 선택하세요.');
      return;
    }
    if (selectedRentList.length === 0) {
      await showAnnAlert('warning', '입력 확인', '공고에 포함할 매물을 선택하세요.');
      return;
    }
    const { pblancBgngDt, pblancEndDt, rcrtBgngDt, rcrtEndDt } = annForm;
    if (!pblancBgngDt || !pblancEndDt || !rcrtBgngDt || !rcrtEndDt) {
      await showAnnAlert('warning', '입력 확인', '게시·모집 기간을 모두 입력하세요.');
      return;
    }
    const dateErr = assertDateOrder(pblancBgngDt, pblancEndDt, rcrtBgngDt, rcrtEndDt);
    if (dateErr) {
      await showAnnAlert('warning', '입력 확인', dateErr);
      return;
    }

    const confirm = await Swal.fire({
      icon: 'question',
      title: '공고 등록',
      text: '입력한 내용으로 공고를 등록할까요?',
      showCancelButton: true,
      confirmButtonText: '등록',
      cancelButtonText: '취소',
      reverseButtons: true,
    });
    if (!confirm.isConfirmed) return;

    setSubmitting(true);
    try {
      const data = await insertAnn(getInsertPayload());
      if (data.success) {
        await Swal.fire({
          icon: 'success',
          title: '공고 등록 완료',
          text: '공고 목록 페이지로 이동합니다.',
          confirmButtonText: '확인',
          timer: 2200,
          timerProgressBar: true,
        });
        navigate(ANN_LIST_PATH, { replace: true });
        return;
      }
      await showAnnAlert(
        'error',
        '등록 실패',
        data.message ?? data.messeage ?? '공고 등록에 실패했습니다.'
      );
    } catch (e) {
      console.error(e);
      const msg =
        e?.response?.data?.message ??
        e?.message ??
        '등록 중 오류가 발생했습니다.';
      await showAnnAlert('error', '등록 오류', msg);
    } finally {
      setSubmitting(false);
    }
  };

  const handleNavigateList = () => navigate(ANN_LIST_PATH);

  // ─────────────────────────────────────────
  // 상위 선택 바뀌면 하위 초기화
  // ─────────────────────────────────────────
  const resetBelow = () => {
    setAptCmplexNo('');
    setAddr('');
    setRentList([]);
    setSelectedRentList([]);
    setHoTyList([]);
    setSubmitDocOptions([]);
  };

  return (
    <>
      <style>{ANN_PAGE_CSS}</style>
      <div className="content-wrapper ann-register-full">
        <header className="page-header" style={{ alignItems: 'flex-start' }}>
          <h1 className="page-title">공고 등록</h1>
        </header>

        <div className="form-sections-stack">
          <BasicInfoSection annForm={annForm} onFieldChange={setAnnField} />
          <AnnInfoSection annForm={annForm} onFieldChange={setAnnField} />
          <SupplyInfoSection
            sido={sido}
            setsido={setsido}
            sigungu={sigungu}
            setsigungu={setsigungu}
            emd={emd}
            setemd={setemd}
            aptCmplexNo={aptCmplexNo}
            setAptCmplexNo={setAptCmplexNo}
            setAddr={setAddr}
            addr={addr}
            sidoOptions={sidoOptions}
            sigunguOptions={sigunguOptions}
            emdOptions={emdOptions}
            aptOptions={aptOptions}
            setHoTyList={setHoTyList}
            hoTyList={hoTyList}
            setSubmitDocOptions={setSubmitDocOptions}
            handleAptChange={handleAptChange}
            resetBelow={resetBelow}
            rentList={rentList}
            selectedRentList={selectedRentList}
            setSelectedRentList={setSelectedRentList}
          />
          <SubmitDocSection submitDocOptions={submitDocOptions} />
        </div>

        <footer
          style={{
            display: 'flex',
            justifyContent: 'flex-end',
            gap: 12,
            paddingTop: 20,
            marginTop: 'auto',
            borderTop: '1px solid var(--outline-variant)',
          }}
        >
          <Button
            type="button"
            className="btn-primary"
            onClick={handleSubmit}
            disabled={submitting}
          >
            {submitting ? '등록 중…' : '등록'}
          </Button>
          <Button
            type="button"
            className="btn-outline"
            onClick={handleNavigateList}
            disabled={submitting}
          >
            목록
          </Button>
        </footer>
      </div>
    </>
  );
}
