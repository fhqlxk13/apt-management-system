package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

/**
 * 방송 송출 대상 <b>한 동</b> 정보.
 * <p>
 * {@link kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller.ManagerBroadcastWsController#startBroadcast}
 * 의 {@link BroadcastStartRequestVO#getTargets()} 요소로 사용됩니다.
 * <ul>
 *   <li>{@code dongNo} — DB 동 코드 (수신 URL·{@code data-dong-no} 와 동일해야 WS 구독이 맞음)</li>
 *   <li>{@code dongLabel} — 화면 표시용 (예: 101동), 없으면 dongNo 로 대체</li>
 * </ul>
 */
@Data
public class BroadcastDongTargetVO {
    private String dongNo;
    private String dongLabel;
}
