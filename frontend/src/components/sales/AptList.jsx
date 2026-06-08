import '../../styles/sales/AptList.css';

const AptList = ({
  aptList,
  selectedApt,
  onSelect,
  loading,
}) => {

  // =========================
  // 로딩
  // =========================
  if (loading) {
    return (
      <div className="apt-list-empty">
        아파트 목록 조회중...
      </div>
    );
  }

  // =========================
  // 빈 데이터
  // =========================
  if (!aptList?.length) {
    return (
      <div className="apt-list-empty">
        조회된 아파트가 없습니다.
      </div>
    );
  }

  return (
    <div className="apt-list-wrap">

      {aptList.map((apt) => {

        const selected =
          selectedApt?.kaptCode === apt.kaptCode;

        return (

          <div
            key={apt.kaptCode}
            className={
              `apt-list-item ${selected ? 'selected' : ''
              }`
            }
            onClick={() => onSelect(apt)}
          >

            <div className="apt-list-name">
              {apt.kaptName}
            </div>

            <div className="apt-list-address">
              {apt.doroJuso}
            </div>

          </div>

        );
      })}

    </div>
  );
};

export default AptList;